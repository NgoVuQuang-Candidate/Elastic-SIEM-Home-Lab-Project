# Elastic-SIEM-Home-Lab-Project
Triển khai hệ thống SIEM Lab toàn diện sử dụng Elastic Stack 8.19.14 trên Ubuntu Server nhằm giám sát và phát hiện các cuộc tấn công Brute Force vào máy ảo Windows.

## Project Overview:
Dự án này triển khai một hệ thống SIEM tập trung sử dụng Elastic Stack 8.19.14 trên môi trường Lab ảo hóa. Mục tiêu chính là thu thập, phân tích Security Event Logs từ máy ảo Windows và tự động phát hiện các cuộc tấn công Brute Force thông qua RDP.

## Architecture

  + SIEM Server: Ubuntu Server (Elasticsearch, Kibana, Fleet Server) - IP: 192.168.52.10

  + Endpoint: Windows 10 VM (Elastic Agent) - IP: 192.168.52.154

  + Attacker: Kali Linux (Hydra) - IP: 192.168.52.151

  + Security: Toàn bộ đường truyền được bảo mật bằng TLS/SSL (Self-signed Certificates).


## Implementation Phases

### Phase 1-4: Setup & Security

  + Triển khai Elasticsearch & Kibana trên Ubuntu Server.

  + Cấu hình Fleet Server và thiết lập Certificate Authority (CA) nội bộ để kích hoạt giao thức HTTPS bảo mật cho toàn bộ hệ thống.

  + Xử lý các lỗi kỹ thuật về Chromium Headless shell và quyền truy cập Keystore.


### Phase 5-7: Log Collection & Detection

  + Cấu hình Integration Windows để thu thập log Event ID 4625 (Failed Logon).

  + Xây dựng Dashboard trực quan hóa các đợt tấn công theo thời gian thực.

  + Thiết lập Detection Rule (Threshold Rule): Cảnh báo ngay lập tức nếu một User đăng nhập sai quá 5 lần trong vòng 2 phút.


### Phase 8: Attack Simulation (The "Real" Test)

  + Sử dụng công cụ Hydra trên Kali Linux để tấn công bẻ khóa RDP máy Windows:

```hydra -l ngovuquang -P pass.txt rdp://192.168.52.154 -t 1 -w 5 -V```

  + Kết quả: SIEM đã ghi nhận thành công 6 lần đăng nhập sai và kích hoạt Alert ngay lập tức.

## Technical Challenges & Troubleshooting

### Lỗi treo khởi động (Kibana Startup Loop)

+ Vấn đề: Hệ thống bị kẹt vô hạn tại dòng nhật ký plugins.screenshotting.chromium.

+ Phân tích: Qua việc kiểm tra log debug và lệnh curl, tôi phát hiện lỗi mismatch giữa node.name và cluster.initial_master_nodes khiến Cluster không thể hình thành.

+ Giải quyết: Cấu hình lại file elasticsearch.yml để đồng bộ tên node và thiết lập discovery.type: single-node.

### Cấu hình HTTPS thủ công cho bản 8.x

+ Vấn đề: Elasticsearch 8.x yêu cầu HTTPS nhưng ban đầu chỉ cấu hình HTTP, gây lỗi kết nối khi bật Security.

+ Giải quyết: Sử dụng openssl để trích xuất Private Key (http_ca.key) từ Keystore .p12. Thiết lập thủ công elasticsearch.ssl.certificateAuthorities trong Kibana để thiết lập lòng tin (Trust) giữa các thành phần stack.

## Evidence & Results

### Agent Connectivity (Fleet)

<img width="2009" height="608" alt="image" src="https://github.com/user-attachments/assets/a60c5a27-d3fd-4e9e-a398-0fb7b30e7b29" />
Hệ thống quản lý tập trung 2 Agent đang hoạt động Healthy qua cổng 8220 (HTTPS).

### Security Monitoring Dashboard

<img width="1345" height="1134" alt="image" src="https://github.com/user-attachments/assets/d4b35b58-02da-42d8-9c53-975ea49ffbed" />
Biểu đồ thể hiện sự gia tăng đột biến của các sự kiện đăng nhập thất bại khi cuộc tấn công diễn ra.

### Automated Alerting

<img width="2452" height="894" alt="image" src="https://github.com/user-attachments/assets/a79de8b4-9590-41f3-9a26-b63a40b9ee4b" />
Alert chi tiết xác định chính xác IP kẻ tấn công (192.168.52.151) và tài khoản mục tiêu (ngovuquang).

## Key Findings & Lessons Learned

+ Security by Design: Việc tự cấu hình TLS/SSL giúp bảo mật dữ liệu log, ngăn chặn kẻ tấn công nghe lén trên đường truyền mạng.

+ Incident Response: Alert cung cấp đầy đủ thông tin về IP nguồn, giúp người quản trị thực hiện các biện pháp ngăn chặn (Blacklist IP) kịp thời.

+ Optimization: Sử dụng tính năng Group by trong Rule giúp giảm thiểu báo động giả (False Positives) cho hệ thống.

=> Để đảm bảo tính toàn vẹn dữ liệu giữa các thành phần, tôi đã cấu hình thủ công TLS cho Elasticsearch và Kibana. Tham khảo file cấu hình và detection rule export từ Kibana tại thư mục /configs, nơi tôi đã thiết lập các tham số về HTTPS và Certificate Authority nội bộ.
