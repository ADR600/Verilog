# UART Protocol 
UART stands for Universl Asynchronous Receiver Transmitter. Meaning it doesnt need clock to operate . 
Unlike SPI where the master sends clock (spi clock) along with data for synchrnoisation in UART there is no clock. 
The communication works on agreed Baud Rate and Frequency.
But like SPI it is a serial protocol meaning it sends its data 1 bit at a time. An 8 bit data is generally send with framing bits like start, stop bit .Parity may or may not be included . 

In this implementation there is no paritu bit.In my design the baud rate can be chnaged indirectly using dvsr which is given as
```

(dvsr + 1) * 16 = frequency

         f
v = -----------  - 1
       16 × b

Where:
- v : divisor (dvsr)
- b : baud rate
- f : input clock frequency (Hz)

```

To achieve synchrnonization between transmitter and receiver we use concept of oversampling . 
In my case I have used 16x Oversampling. Which is obvisous from the equation.  Meaning the bit send by the sender changes every 16 ticks (1 tick is 0 to dvsr).

### Features of this UART Implemented
```

8 bit data ( can be 6 ,7, bits long)
1 start,stop bit
no parity bit
stop bit is of 1 bit wide (can be 1.5 or 2 bits long)
Changeable  baud rate using dvsr
Oversampling  16x

```

### Thanks to  
https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter
https://www.rohde-schwarz.com/us/products/test-and-measurement/essentials-test-equipment/digital-oscilloscopes/understanding-uart_254524.html
