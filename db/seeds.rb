# AWS SAA-C03 Certification Study App - Seed Data

# Clean existing data
UserAnswer.destroy_all
UserProgress.destroy_all
Question.destroy_all
Lesson.destroy_all
Domain.destroy_all
User.destroy_all

puts "Creating AWS SAA-C03 Domains..."

# AWS SAA-C03 Exam Domains (based on official exam guide)
domains_data = [
  {
    name: "Design Resilient Architectures",
    description: "Design scalable and loosely coupled architectures, design highly available and/or fault-tolerant architectures, and design decoupling mechanisms using AWS services.",
    position: 1,
    weight: 0.26 # 26% of exam
  },
  {
    name: "Design High-Performing Architectures", 
    description: "Choose performant storage and databases, design solutions for elasticity and scalability, and design networking solutions.",
    position: 2,
    weight: 0.24 # 24% of exam
  },
  {
    name: "Design Secure Applications and Architectures",
    description: "Design secure access to AWS resources, design secure workloads and applications, and determine appropriate data security controls.",
    position: 3,
    weight: 0.30 # 30% of exam
  },
  {
    name: "Design Cost-Optimized Architectures",
    description: "Design cost-optimized storage solutions, compute solutions, database solutions, and network architectures.",
    position: 4,
    weight: 0.20 # 20% of exam
  }
]

domains = domains_data.map do |domain_attrs|
  domain = Domain.create!(domain_attrs)
  puts "  ✓ Created domain: #{domain.name}"
  domain
end

puts "\nCreating Lessons and Questions..."

# Domain 1: Design Resilient Architectures
resilient_domain = domains[0]

lesson1 = resilient_domain.lessons.create!(
  title: "Introduction to AWS Global Infrastructure",
  content: "AWS Global Infrastructure consists of Regions, Availability Zones (AZs), and Edge Locations. Understanding this infrastructure is crucial for designing resilient architectures.",
  position: 1
)

lesson1.questions.create!([
  {
    question_type: "multiple_choice",
    content: "Which AWS service allows you to run applications across multiple Availability Zones for high availability?",
    correct_answer: "Elastic Load Balancing",
    options: ["Elastic Load Balancing", "Amazon Route 53", "AWS CloudFormation", "Amazon VPC"],
    explanation: "Elastic Load Balancing distributes incoming application traffic across multiple targets, such as EC2 instances, in multiple Availability Zones.",
    experience_points: 15
  },
  {
    question_type: "true_false", 
    content: "AWS Regions are connected through high-bandwidth, low-latency networking.",
    correct_answer: "True",
    explanation: "AWS Regions are connected through high-bandwidth, low-latency networking, which enables services like cross-region replication.",
    experience_points: 10
  },
  {
    question_type: "multiple_choice",
    content: "What is the minimum number of Availability Zones in an AWS Region?",
    correct_answer: "2",
    options: ["1", "2", "3", "4"],
    explanation: "Each AWS Region has a minimum of two Availability Zones, though most have three or more.",
    experience_points: 10
  }
])

lesson2 = resilient_domain.lessons.create!(
  title: "Auto Scaling and Load Balancing",
  content: "Learn how to implement automatic scaling and load distribution to handle varying loads and maintain availability.",
  position: 2
)

lesson2.questions.create!([
  {
    question_type: "multiple_choice",
    content: "Which type of load balancer is best for HTTP/HTTPS traffic with advanced routing?",
    correct_answer: "Application Load Balancer (ALB)",
    options: ["Classic Load Balancer", "Application Load Balancer (ALB)", "Network Load Balancer (NLB)", "Gateway Load Balancer"],
    explanation: "Application Load Balancer is ideal for HTTP/HTTPS traffic and provides advanced routing features like path-based and host-based routing.",
    experience_points: 15
  },
  {
    question_type: "scenario",
    content: "Your web application experiences traffic spikes during business hours. Which Auto Scaling policy would be most effective?",
    correct_answer: "Scheduled scaling with predictive scaling",
    options: ["Target tracking scaling only", "Scheduled scaling with predictive scaling", "Manual scaling only", "Step scaling only"],
    explanation: "For predictable traffic patterns, scheduled scaling combined with predictive scaling provides the best performance and cost optimization.",
    experience_points: 20
  }
])

# Domain 2: Design High-Performing Architectures
performance_domain = domains[1]

lesson3 = performance_domain.lessons.create!(
  title: "Storage Solutions and Performance",
  content: "Compare different AWS storage solutions and their performance characteristics for various use cases.",
  position: 1
)

lesson3.questions.create!([
  {
    question_type: "multiple_choice",
    content: "Which EBS volume type provides the highest IOPS performance?",
    correct_answer: "Provisioned IOPS SSD (io2)",
    options: ["General Purpose SSD (gp3)", "Provisioned IOPS SSD (io2)", "Throughput Optimized HDD (st1)", "Cold HDD (sc1)"],
    explanation: "Provisioned IOPS SSD (io2) volumes can deliver up to 64,000 IOPS and are designed for I/O-intensive applications.",
    experience_points: 15
  },
  {
    question_type: "multiple_choice",
    content: "Which storage class is most cost-effective for data accessed once or twice per year?",
    correct_answer: "S3 Glacier Deep Archive",
    options: ["S3 Standard", "S3 Intelligent-Tiering", "S3 Glacier Flexible Retrieval", "S3 Glacier Deep Archive"],
    explanation: "S3 Glacier Deep Archive is the lowest-cost storage class, designed for long-term retention of data accessed once or twice per year.",
    experience_points: 15
  }
])

# Domain 3: Design Secure Applications and Architectures  
security_domain = domains[2]

lesson4 = security_domain.lessons.create!(
  title: "IAM Policies and Access Control",
  content: "Learn how to implement proper access controls using AWS Identity and Access Management (IAM).",
  position: 1
)

lesson4.questions.create!([
  {
    question_type: "multiple_choice",
    content: "What is the principle of least privilege in IAM?",
    correct_answer: "Grant only the permissions needed to perform a task",
    options: ["Grant all permissions by default", "Grant only the permissions needed to perform a task", "Grant read-only access to all resources", "Grant administrator access to trusted users"],
    explanation: "The principle of least privilege means granting users, groups, or roles only the minimum permissions necessary to perform their intended tasks.",
    experience_points: 15
  },
  {
    question_type: "true_false",
    content: "IAM roles can be assumed by AWS services, users, and applications.",
    correct_answer: "True", 
    explanation: "IAM roles can be assumed by AWS services (like EC2), federated users, applications, and other AWS accounts when properly configured.",
    experience_points: 10
  }
])

# Domain 4: Design Cost-Optimized Architectures
cost_domain = domains[3]

lesson5 = cost_domain.lessons.create!(
  title: "Cost Optimization Strategies",
  content: "Learn strategies to optimize costs while maintaining performance and reliability.",
  position: 1
)

lesson5.questions.create!([
  {
    question_type: "multiple_choice", 
    content: "Which EC2 purchasing option provides the lowest cost for predictable workloads?",
    correct_answer: "Reserved Instances",
    options: ["On-Demand Instances", "Reserved Instances", "Spot Instances", "Dedicated Hosts"],
    explanation: "Reserved Instances provide significant cost savings (up to 75%) for predictable workloads with 1 or 3-year commitments.",
    experience_points: 15
  },
  {
    question_type: "scenario",
    content: "Your application has unpredictable traffic and can tolerate interruptions. Which EC2 option should you choose?",
    correct_answer: "Spot Instances",
    options: ["On-Demand Instances", "Reserved Instances", "Spot Instances", "Dedicated Instances"],
    explanation: "Spot Instances can provide up to 90% savings and are ideal for fault-tolerant, flexible applications that can handle interruptions.",
    experience_points: 20
  }
])

# Create a demo user
demo_user = User.create!(
  email: "demo@awsstudy.com",
  password: "password123",
  name: "Demo Student"
)

puts "\nCreated demo user: #{demo_user.email} (password: password123)"

puts "\n🎉 Seed data created successfully!"
puts "\nSummary:"
puts "  • #{Domain.count} domains"
puts "  • #{Lesson.count} lessons" 
puts "  • #{Question.count} questions"
puts "  • #{User.count} users"
puts "\nRun 'bin/rails server' to start the application!"
