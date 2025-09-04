class GamesController < ApplicationController
  before_action :require_user

  def index
    @total_games = game_methods.count
    @games_played = session[:games_played] || {}
    @total_xp_earned = session[:games_xp] || 0
  end

  def service_match
    @aws_services = [
      { name: "Amazon EC2", description: "Virtual servers in the cloud", category: "Compute" },
      { name: "Amazon S3", description: "Object storage service", category: "Storage" },
      { name: "Amazon RDS", description: "Managed relational database", category: "Database" },
      { name: "AWS Lambda", description: "Serverless compute service", category: "Compute" },
      { name: "Amazon VPC", description: "Virtual private cloud networking", category: "Networking" },
      { name: "Amazon CloudFront", description: "Content delivery network", category: "Networking" },
      { name: "Amazon DynamoDB", description: "NoSQL database service", category: "Database" },
      { name: "AWS IAM", description: "Identity and access management", category: "Security" },
      { name: "Amazon EBS", description: "Block storage for EC2", category: "Storage" },
      { name: "AWS CloudWatch", description: "Monitoring and observability", category: "Management" }
    ]
    @categories = @aws_services.map { |s| s[:category] }.uniq
    @shuffled_services = @aws_services.shuffle
  end

  def check_service_match
    correct_matches = 0
    total_matches = params[:matches].to_i

    params[:service_matches].each do |service_name, selected_category|
      service = find_service_by_name(service_name)
      if service && service[:category] == selected_category
        correct_matches += 1
      end
    end

    score_percentage = (correct_matches.to_f / total_matches * 100).round
    xp_earned = calculate_game_xp(score_percentage, :service_match)

    current_user.add_experience!(xp_earned)
    track_game_played(:service_match, score_percentage)

    render json: {
      correct: correct_matches,
      total: total_matches,
      score: score_percentage,
      xp_earned: xp_earned,
      message: get_score_message(score_percentage)
    }
  end

  def architecture_challenge
    @architecture_scenarios = [
      {
        title: "High Availability Web Application",
        description: "Design a 3-tier web application with high availability across multiple AZs",
        components: [
          { name: "Application Load Balancer", type: "Load Balancer", required: true },
          { name: "Auto Scaling Group", type: "Compute", required: true },
          { name: "Amazon RDS Multi-AZ", type: "Database", required: true },
          { name: "Amazon S3", type: "Storage", required: false },
          { name: "Amazon CloudFront", type: "CDN", required: false },
          { name: "Amazon ElastiCache", type: "Cache", required: false }
        ]
      }
    ]
    @current_scenario = @architecture_scenarios.sample
  end

  def check_architecture
    scenario = find_architecture_scenario_by_title(params[:scenario_title])
    selected_components = params[:selected_components] || []

    required_components = scenario[:components].select { |c| c[:required] }.map { |c| c[:name] }

    correct_selections = selected_components.select { |c| required_components.include?(c) }
    incorrect_selections = selected_components.reject { |c| required_components.include?(c) }

    score_percentage = if required_components.empty?
      100
    else
      ((correct_selections.length - incorrect_selections.length).to_f / required_components.length * 100).round.clamp(0, 100)
    end

    xp_earned = calculate_game_xp(score_percentage, :architecture_challenge)

    current_user.add_experience!(xp_earned)
    track_game_played(:architecture_challenge, score_percentage)

    render json: {
      correct: correct_selections.length,
      total_required: required_components.length,
      score: score_percentage,
      xp_earned: xp_earned,
      message: get_score_message(score_percentage)
    }
  end

  def quick_quiz
    @quiz_questions = session[:quiz_questions] || [
      {
        question: "Which AWS service provides a fully managed NoSQL database?",
        options: [ "Amazon RDS", "Amazon DynamoDB", "Amazon Redshift", "Amazon ElastiCache" ],
        correct: "Amazon DynamoDB",
        explanation: "DynamoDB is AWS's fully managed NoSQL database service with single-digit millisecond latency."
      },
      {
        question: "What is the maximum size for a single S3 object?",
        options: [ "1 TB", "5 TB", "10 TB", "Unlimited" ],
        correct: "5 TB",
        explanation: "The maximum size for a single S3 object is 5 TB, though you can use multipart upload for objects larger than 100 MB."
      },
      {
        question: "Which service would you use for serverless compute?",
        options: [ "Amazon EC2", "Amazon ECS", "AWS Lambda", "Amazon Lightsail" ],
        correct: "AWS Lambda",
        explanation: "Lambda is AWS's serverless compute service that runs code without provisioning servers."
      },
      {
        question: "What does VPC stand for?",
        options: [ "Virtual Private Cloud", "Virtual Public Cloud", "Virtual Protected Cloud", "Virtual Processing Cloud" ],
        correct: "Virtual Private Cloud",
        explanation: "VPC stands for Virtual Private Cloud, providing isolated network environments in AWS."
      },
      {
        question: "Which storage class is most cost-effective for long-term archival?",
        options: [ "S3 Standard", "S3 IA", "S3 Glacier Deep Archive", "S3 One Zone-IA" ],
        correct: "S3 Glacier Deep Archive",
        explanation: "S3 Glacier Deep Archive is the lowest-cost storage class for long-term retention of data accessed rarely."
      }
    ]

    session[:quiz_questions] = @quiz_questions.shuffle
    session[:current_quiz_question_index] = 0
    session[:current_quiz_score] = 0

    @current_question = session[:quiz_questions][session[:current_quiz_question_index]]
  end

  def check_quiz
    questions = session[:quiz_questions]
    current_index = session[:current_quiz_question_index]

    selected_answer = params[:selected_answer]
    correct_answer = questions[current_index][:correct]

    if selected_answer == correct_answer
      session[:current_quiz_score] += 1
    end

    session[:current_quiz_question_index] += 1

    if session[:current_quiz_question_index] >= questions.length
      score_percentage = (session[:current_quiz_score].to_f / questions.length * 100).round
      xp_earned = calculate_game_xp(score_percentage, :quick_quiz)

      current_user.add_experience!(xp_earned)
      track_game_played(:quick_quiz, score_percentage)

      render json: {
        game_over: true,
        correct_answers: session[:current_quiz_score],
        total_questions: questions.length,
        score: score_percentage,
        xp_earned: xp_earned
      }
    else
      next_question = questions[session[:current_quiz_question_index]]
      render json: {
        game_over: false,
        next_question_html: render_to_string(partial: "games/quiz_question", locals: { question: next_question })
      }
    end
  end

  def cost_calculator
    @aws_services_pricing = [
      { name: "EC2 t3.micro", price_per_hour: 0.0104, unit: "hour" },
      { name: "EC2 m5.large", price_per_hour: 0.096, unit: "hour" },
      { name: "S3 Standard Storage", price_per_gb: 0.023, unit: "GB/month" },
      { name: "RDS MySQL t3.micro", price_per_hour: 0.017, unit: "hour" },
      { name: "Lambda Requests", price_per_million: 0.20, unit: "1M requests" },
      { name: "CloudFront Data Transfer", price_per_gb: 0.085, unit: "GB" }
    ]

    @cost_scenarios = [
      {
        title: "Startup Web Application",
        description: "Calculate monthly cost for a small web app",
        requirements: {
          "EC2 instances": "2 x t3.micro (24/7)",
          "S3 storage": "100 GB",
          "RDS database": "1 x t3.micro (24/7)",
          "Data transfer": "500 GB/month"
        },
        correct_total: 52.35
      }
    ]
  end

  def check_cost
    scenario = find_cost_scenario_by_title(params[:scenario_title])
    user_total = params[:user_total].to_f
    correct_total = scenario[:correct_total]

    difference = (user_total - correct_total).abs

    # Score is based on how close the user is to the correct answer
    score_percentage = [ 100 - (difference / correct_total * 100), 0 ].max.round

    xp_earned = calculate_game_xp(score_percentage, :cost_calculator)

    current_user.add_experience!(xp_earned)
    track_game_played(:cost_calculator, score_percentage)

    render json: {
      difference: difference,
      score: score_percentage,
      xp_earned: xp_earned,
      message: get_score_message(score_percentage)
    }
  end

  def scenario_tree
    @scenarios = get_all_scenarios
    @current_scenario = @scenarios.first
    session[:scenario_score] = 0
  end

  def check_scenario
    next_scenario_id_str = params[:next_scenario_id]
    chosen_points = params[:points].to_i # Get points from the selected option

    session[:scenario_score] ||= 0 # Initialize score if not present
    session[:scenario_score] += chosen_points # Add points for the chosen option

    if next_scenario_id_str == "end"
      # End of scenario
      score_percentage = (session[:scenario_score].to_f / 35 * 100).round.clamp(0, 100) # Max score is 35
      xp_earned = calculate_game_xp(score_percentage, :scenario_tree)

      current_user.add_experience!(xp_earned)
      track_game_played(:scenario_tree, score_percentage)

      render json: {
        game_over: true,
        total_score: session[:scenario_score],
        score: score_percentage,
        xp_earned: xp_earned
      }
    else
      next_scenario_id = next_scenario_id_str.to_i
      next_scenario = get_all_scenarios.find { |s| s[:id] == next_scenario_id }

      if next_scenario
        render json: {
          game_over: false,
          next_scenario_html: render_to_string(partial: "games/scenario_step", locals: { scenario: next_scenario })
        }
      else
        # Handle case where scenario is not found, maybe end the game.
        render json: { game_over: true, error: "Scenario not found" }, status: :not_found
      end
    end
  end

  private

  def find_service_by_name(name)
    [
      { name: "Amazon EC2", description: "Virtual servers in the cloud", category: "Compute" },
      { name: "Amazon S3", description: "Object storage service", category: "Storage" },
      { name: "Amazon RDS", description: "Managed relational database", category: "Database" },
      { name: "AWS Lambda", description: "Serverless compute service", category: "Compute" },
      { name: "Amazon VPC", description: "Virtual private cloud networking", category: "Networking" },
      { name: "Amazon CloudFront", description: "Content delivery network", category: "Networking" },
      { name: "Amazon DynamoDB", description: "NoSQL database service", category: "Database" },
      { name: "AWS IAM", description: "Identity and access management", category: "Security" },
      { name: "Amazon EBS", description: "Block storage for EC2", category: "Storage" },
      { name: "AWS CloudWatch", description: "Monitoring and observability", category: "Management" }
    ].find { |service| service[:name] == name }
  end

  def find_architecture_scenario_by_title(title)
    [
      {
        title: "High Availability Web Application",
        description: "Design a 3-tier web application with high availability across multiple AZs",
        components: [
          { name: "Application Load Balancer", type: "Load Balancer", required: true },
          { name: "Auto Scaling Group", type: "Compute", required: true },
          { name: "Amazon RDS Multi-AZ", type: "Database", required: true },
          { name: "Amazon S3", type: "Storage", required: false },
          { name: "Amazon CloudFront", type: "CDN", required: false },
          { name: "Amazon ElastiCache", type: "Cache", required: false }
        ]
      }
    ].find { |scenario| scenario[:title] == title }
  end

  def find_cost_scenario_by_title(title)
    [
      {
        title: "Startup Web Application",
        description: "Calculate monthly cost for a small web app",
        requirements: {
          "EC2 instances": "2 x t3.micro (24/7)",
          "S3 storage": "100 GB",
          "RDS database": "1 x t3.micro (24/7)",
          "Data transfer": "500 GB/month"
        },
        correct_total: 52.35
      }
    ].find { |scenario| scenario[:title] == title }
  end

  def get_all_scenarios
    [
      {
        id: 1,
        title: "Database Performance Issue",
        description: "Your RDS MySQL database is experiencing high CPU utilization and slow query response times.",
        options: [
          { text: "Scale up to a larger instance type", next_scenario: 2, points: 5 },
          { text: "Add read replicas", next_scenario: 3, points: 10 },
          { text: "Implement ElastiCache", next_scenario: 4, points: 15 }
        ]
      },
      {
        id: 2,
        title: "After Scaling Up",
        description: "The larger instance helped temporarily, but costs have increased. What's next?",
        options: [
          { text: "Analyze slow query logs", next_scenario: "end", points: 20 },
          { text: "Keep the larger instance", next_scenario: "end", points: 5 }
        ]
      },
      {
        id: 3,
        title: "After Adding Read Replicas",
        description: "Read traffic is now distributed, but write operations are still slow.",
        options: [
          { text: "Optimize write queries", next_scenario: "end", points: 20 },
          { text: "Increase instance size", next_scenario: 2, points: 5 }
        ]
      },
      {
        id: 4,
        title: "After Implementing ElastiCache",
        description: "Database load is reduced, but there are cache misses for some queries.",
        options: [
          { text: "Increase cache size", next_scenario: "end", points: 10 },
          { text: "Analyze and optimize cache usage", next_scenario: "end", points: 20 }
        ]
      }
    ]
  end

  def calculate_game_xp(score_percentage, game_type)
    base_xp = {
      service_match: 20,
      architecture_challenge: 30,
      cost_calculator: 25,
      quick_quiz: 15,
      scenario_tree: 35
    }

    xp = base_xp[game_type] || 20

    # Bonus XP for high scores
    if score_percentage >= 90
      xp += 10
    elsif score_percentage >= 80
      xp += 5
    end

    xp
  end

  def track_game_played(game_type, score)
    session[:games_played] ||= {}
    session[:games_played][game_type] ||= []
    session[:games_played][game_type] << {
      score: score,
      played_at: Time.current
    }

    session[:games_xp] ||= 0
    # Don't double count XP here since it's already added in the check methods
  end

  def get_score_message(score)
    case score
    when 90..100
      "🏆 AWS Expert! Outstanding work!"
    when 80..89
      "🎯 Great job! You're getting the hang of AWS!"
    when 70..79
      "👍 Good effort! Keep practicing!"
    when 60..69
      "📚 You're learning! Review the concepts and try again."
    else
      "🔄 Don't give up! Practice makes perfect!"
    end
  end

  def game_methods
    [ :service_match, :architecture_challenge, :cost_calculator, :quick_quiz, :scenario_tree ]
  end
end
