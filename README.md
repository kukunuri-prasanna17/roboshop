Roboshop – Manual Deployment on AWS (Without Automation)

This project demonstrates the complete manual deployment of the Roboshop microservices application using AWS EC2 instances.
All services were installed, configured, and integrated without Terraform / Ansible, fully using Linux commands.

🧩 Project Highlights

✔ Deployed 12 microservices manually
✔ Configured NodeJS, MongoDB, Redis, MySQL, RabbitMQ
✔ Created systemd service files for all components
✔ Setup Nginx Reverse Proxy for frontend
✔ Managed firewall, ports, and service dependencies
✔ Performed manual troubleshooting & logs monitoring

🏗️ Architecture Overview

Frontend → Nginx

Backend Services → NodeJS / Python / Java

Database Layer → MongoDB, MySQL, Redis

Message Broker → RabbitMQ

Internal Communication → Private IPs

OS → Amazon Linux 



🛠️ Technologies Used

* AWS EC2

* Linux (Amazon Linux )

* NodeJS, Python, Java

* MongoDB, MySQL, Redis

* RabbitMQ

* Nginx

* systemd services

* Gitbash
  
* VS



📝 Conclusion

This project showcases a complete end-to-end manual deployment workflow just like real-world DevOps troubleshooting, dependency management, service configuration, and environment setup.
