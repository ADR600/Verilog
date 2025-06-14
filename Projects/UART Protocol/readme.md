UART stands for Universl Asynchronous Receiver Transmitter. Meaning it doesnt need clock to operate . 
Unlike SPI where the master sends clock (spi clock) along with data for synchrnoisation in UART there is no clock. 
The communication works on agreed Baud Rate and Frequency.
But like SPI it is a serial protocol meaning it sends its data 1 bit at a time. An 8 bit data is generally send with framing bits like start, stop bit .Parity may or may not be included . 
In this implementation there is no paritu bit.In my design the baud rate can be chnaged indirectly using dvsr which is given as

#### (dvsr +1 )*16 = frequency 

(dvsr + 1) * 16 = frequency

   ###       f
### v = -----------  - 1
    ###    16 × b

Where:
- v : divisor (dvsr)
- b : baud rate
- f : input clock frequency (Hz)


 v is dvsr
 b - baud rate 
 f - frequency 

To achieve synchrnonization between transmitter and receiver we use concept of oversampling . 
In my case I have used 16x Oversampling. Which is obvisous from the equation.  Meaning the bit send by the sender changes every 16 ticks (1 tick is 0 to dvsr).
The         
-- no parity 
-- start bit
-- stop bit
-- clock 

Transmitter 
------------
load entire byte 
send one bit at a time 
during idle the wire is kept high
for first time wire is made low  (start bit)
8 bits of data 
make wire back to one bit or more -1 ,1.5 ,2 bits 

Receiver  using oversampling 
------------
16 ticks per bit
wait for incoming bit to become 0 
use a counter and sample exactly at middle
for first time
--counter is 16 count ,sample when counter reach 7 then reset
after that 
--after that count till 15 which is middle of first bit 
