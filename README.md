โปรแกรมนี้

1. รับค่าตัวแปร T1, T2, T3, N จาก constructor
2. มี 4 functions
    1. _reset - private ใช้ในการเริ่มต้นเกมใหม่หลังเกมจบหรือมีการถอนเงินเกิดขึ้น
    2. addUser - เพิ่มผู้เล่น โดยต้องมีการจ่ายเงิน 1 finney พร้อมทั้ังใส่ choice และ salt ในการเก็บ hash ของ choice ที่ผู้เล่นเลือก
    3. revealChoice - เฉลยคำตอบที่ตนเองเลือก ต้องส่งมาทั้ง choice และ salt
    4. checkWinner - เลือกได้แค่ owner ของ contract นี้เท่านั้น ระบบจะจ่ายเงินคืนผู้เล่นที่ชนะ หากผู้เล่นมี่ชนะทำผิดกฏเงินทั้งหมดจะตกมาให้ owner ในกรณีปกติจะโอนเงินให้ผู้เล่น 98% ของเงินทั้งหมดและอีก 2% ให้ owner

address ที่ deploy เกมลงไป (มีปัญหากับระบบ withdraw)
![Alt text](./picture/00.png?raw=true "addr 1")

address ที่ deploy เกมลงไป (แก้ไข)
![Alt text](./picture/01.png?raw=true "addr 2")

ตัวอย่าง
1. เล่นแบบปกติ
    - ผู้เล่นเลือก choice และ salt
        ![Alt text](./picture/10.png?raw=true "P1")
        ![Alt text](./picture/11.png?raw=true "P2")
    - ผู้เล่น reveal choice ของตน
        ![Alt text](./picture/12.png?raw=true "P1")
        ![Alt text](./picture/13.png?raw=true "P2")
    - Owner ทำการหาผู้ชนะ
        ![Alt text](./picture/14.png?raw=true "Check")
    - โอนเงินให้ผู้ชนะ
        ![Alt text](./picture/15.png?raw=true "Winner")
2. ผู้ชนะเล่นผิดกฏ
    - ผู้เล่นเลือก choice และ salt
        ![Alt text](./picture/20.png?raw=true "P1")
        ![Alt text](./picture/21.png?raw=true "P2")
    - ผู้เล่น reveal choice ของตน
        ![Alt text](./picture/22.png?raw=true "P2")
    - Owner ทำการหาผู้ชนะ
        ![Alt text](./picture/23.png?raw=true "Check")
    - โอนเงินให้ owner
        ![Alt text](./picture/24.png?raw=true "Winner")
3. owner ไม่ทำการตรวจสอบผู้ชนะ (user ขอ withdraw)
    - ผู้เล่นเลือก choice และ salt
        ![Alt text](./picture/30.png?raw=true "P1")
        ![Alt text](./picture/31.png?raw=true "P2")
    - ผู้เล่น reveal choice ของตน
        ![Alt text](./picture/32.png?raw=true "P1")
        ![Alt text](./picture/33.png?raw=true "P2")
    - ผู้เล่นกดของเงินคืน
        ![Alt text](./picture/34.png?raw=true "Check")
    - โอนเงินให้ผู้เล่นทั้งหมด
        ![Alt text](./picture/35.png?raw=true "Winner")