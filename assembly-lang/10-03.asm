; FUNCTIONS: or SUBROUTINES with ARGUMENTS
[org 0x0100]

jmp start
data: dw 4, 3, 1, 5
swap_flag: db 0 ; let make this local varaible


swap: 
  push ax
  push dx
  
  mov ax, [bx + si]
  mov dx, [bx + si + 2]
  mov [bx + si], dx
  mov [bx + si + 2], ax    

  pop dx
  pop ax                  
  
  ret


bubblesort: 
  push bp
  mov bp, sp

  sub sp, 2 ; make space on the stack, just below BP for local variables

  push ax
  push bx
  push cx
  push si

  ; accepting arguments through bp
  mov bx, [bp + 6]
  mov cx, [bp + 4] ; one stack push is from call, and other stack push is from push bp


  dec cx ; cx is set in start function
  shl cx, 1 ; because we are using words not bytes for numbers, so it will double the cx value

  mainloop: 
    mov si, 0 ; use as array index
    mov word [bp - 2], 0 ; this is is_swapped variable
    ; because we are writing in memory, we have to tell if we are writing word or byte

    innerloop: 
      mov ax, [bx + si]
      cmp ax, [bx + si + 2]
      jbe noswap

        ; swapping logic
        call swap
        mov word [bp - 2], 1

      noswap:
        add si, 2
        cmp si, cx
        jne innerloop

    cmp word [bp - 2], 1 ; if there is a swap
    je mainloop

  pop si
  pop cx
  pop bx
  pop ax

  mov sp, bp ; restore the sp before popping bp

  pop bp

  ; by default with no args, ret only pop 2 bytes of ip
  ret 4 ; this will pop 6 bytes total, 2 of ip and 4 bytes of argument words (2 words)


start: 
  mov bx, data
  mov cx, 4 ; length of elements (array)

  ; providing function arguments
  push bx ; first arg, data
  push cx ; second arg, length
  ; make a function call
  call bubblesort
  ; data is now sorted

mov ax, 0x4c00 ; exit code ..
int 0x21 ; .. is what the OS should do for me
