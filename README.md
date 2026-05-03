# Elastic-SIEM-Home-Lab-Project
A comprehensive Home SIEM Lab setup using Elastic Stack 8.19.14 on Ubuntu Server to monitor and detect Brute Force attacks on a Windows VM.

-Project Overview:
Dự án này triển khai một hệ thống SIEM tập trung sử dụng Elastic Stack 8.19.14 trên môi trường Lab ảo hóa. Mục tiêu chính là thu thập, phân tích Security Event Logs từ máy ảo Windows và tự động phát hiện các cuộc tấn công Brute Force thông qua RDP.

-Architecture

  + SIEM Server: Ubuntu Server (Elasticsearch, Kibana, Fleet Server) - IP: 192.168.52.10

  + Endpoint: Windows 10 VM (Elastic Agent) - IP: 192.168.52.154

  + Attacker: Kali Linux (Hydra) - IP: 192.168.52.151

  + Security: Toàn bộ đường truyền được bảo mật bằng TLS/SSL (Self-signed Certificates).


-Implementation Phases

1. Phase 1-4: Setup & Security

  + Triển khai Elasticsearch & Kibana trên Ubuntu Server.

  + Cấu hình Fleet Server và thiết lập Certificate Authority (CA) nội bộ để kích hoạt giao thức HTTPS bảo mật cho toàn bộ hệ thống.

  + Xử lý các lỗi kỹ thuật về Chromium Headless shell và quyền truy cập Keystore.


2. Phase 5-7: Log Collection & Detection

  + Cấu hình Integration Windows để thu thập log Event ID 4625 (Failed Logon).

  + Xây dựng Dashboard trực quan hóa các đợt tấn công theo thời gian thực.

  + Thiết lập Detection Rule (Threshold Rule): Cảnh báo ngay lập tức nếu một User đăng nhập sai quá 5 lần trong vòng 2 phút.


3. Phase 8: Attack Simulation (The "Real" Test)

  + Sử dụng công cụ Hydra trên Kali Linux để tấn công bẻ khóa RDP máy Windows: hydra -l ngovuquang -P pass.txt rdp://192.168.52.154 -t 1 -w 5 -V

  + Kết quả: SIEM đã ghi nhận thành công 6 lần đăng nhập sai và kích hoạt Alert ngay lập tức.


-Evidence & Results

1. Agent Connectivity (Fleet)

<img width="2009" height="608" alt="image" src="https://github.com/user-attachments/assets/a60c5a27-d3fd-4e9e-a398-0fb7b30e7b29" />
Hệ thống quản lý tập trung 2 Agent đang hoạt động Healthy qua cổng 8220 (HTTPS).

3. Security Monitoring Dashboard

<img width="1345" height="1134" alt="image" src="https://github.com/user-attachments/assets/d4b35b58-02da-42d8-9c53-975ea49ffbed" />
Biểu đồ thể hiện sự gia tăng đột biến của các sự kiện đăng nhập thất bại khi cuộc tấn công diễn ra.

5. Automated Alerting

<img width="2452" height="894" alt="image" src="https://github.com/user-attachments/assets/a79de8b4-9590-41f3-9a26-b63a40b9ee4b" />
Alert chi tiết xác định chính xác IP kẻ tấn công (192.168.52.151) và tài khoản mục tiêu (ngovuquang).


=> Để đảm bảo tính toàn vẹn dữ liệu giữa các thành phần, tôi đã cấu hình thủ công TLS cho Elasticsearch và Kibana. Tham khảo file cấu hình tại thư mục /configs, nơi tôi đã thiết lập các tham số về HTTPS và Certificate Authority nội bộ.
