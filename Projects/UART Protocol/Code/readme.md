## Structure of Design  
```
------------------------------
Top module 
------------------------------

Transmitter --> Receiver

------------------------------
Receiver
------------------------------
  Receiver FSM 
  FIFO 
  Baud Rate Generator

------------------------------
Transmitter
------------------------------
  Transmitter FSM 
  FIFO 
  Baud Rate Generator
  
```

## Top module
-----------------
Write to transmitter fifo 

Read from receiver fifo  

Data transfered between them adhering to UART Protocol 

![image](https://github.com/user-attachments/assets/f98e864c-b8f5-4c59-bfa7-1398aa25fb2a)

reset already done , so it appears as 5 output 
