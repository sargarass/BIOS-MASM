
1.bin:     формат файла binary


Дизассемблирование раздела .data:

00000000 <.data>:
   0:	55                   	push   %bp
   1:	aa                   	stos   %al,%es:(%di)
   2:	02 eb                	add    %bl,%ch
   4:	17                   	pop    %ss
   5:	54                   	push   %sp
   6:	6f                   	outsw  %ds:(%si),(%dx)
   7:	6f                   	outsw  %ds:(%si),(%dx)
   8:	6c                   	insb   (%dx),%es:(%di)
   9:	62 6f 78             	bound  %bp,0x78(%bx)
   c:	20 42 49             	and    %al,0x49(%bp,%si)
   f:	4f                   	dec    %di
  10:	53                   	push   %bx
  11:	20 31                	and    %dh,(%bx,%di)
  13:	2e 30 0d             	xor    %cl,%cs:(%di)
  16:	0a 00                	or     (%bx,%si),%al
  18:	aa                   	stos   %al,%es:(%di)
  19:	72 ff                	jb     0x1a
  1b:	55                   	push   %bp
  1c:	8c c8                	mov    %cs,%ax
  1e:	8e d8                	mov    %ax,%ds
  20:	31 c0                	xor    %ax,%ax
  22:	8e c0                	mov    %ax,%es
  24:	26 8c 0e 82 01       	mov    %cs,%es:0x182
  29:	26 c7 06 80 01 85 00 	movw   $0x85,%es:0x180
  30:	0e                   	push   %cs
  31:	68 05 00             	push   $0x5
  34:	6a 00                	push   $0x0
  36:	cd 60                	int    $0x60
  38:	83 c4 06             	add    $0x6,%sp
  3b:	6a 1f                	push   $0x1f
  3d:	cd 60                	int    $0x60
  3f:	83 c4 02             	add    $0x2,%sp
  42:	cb                   	lret   
  43:	aa                   	stos   %al,%es:(%di)
  44:	00 aa 00 a2          	add    %ch,-0x5e00(%bp,%si)
  48:	00 a2 00 a2          	add    %ah,-0x5e00(%bp,%si)
  4c:	00 a2 00 a2          	add    %ah,-0x5e00(%bp,%si)
  50:	00 a2 00 a2          	add    %ah,-0x5e00(%bp,%si)
  54:	00 a2 00 a2          	add    %ah,-0x5e00(%bp,%si)
  58:	00 a2 00 a2          	add    %ah,-0x5e00(%bp,%si)
  5c:	00 a2 00 a2          	add    %ah,-0x5e00(%bp,%si)
  60:	00 a2 00 a2          	add    %ah,-0x5e00(%bp,%si)
  64:	00 e6                	add    %ah,%dh
  66:	00 f0                	add    %dh,%al
  68:	00 a2 00 fa          	add    %ah,-0x600(%bp,%si)
  6c:	00 a2 00 a2          	add    %ah,-0x5e00(%bp,%si)
  70:	00 a2 00 a2          	add    %ah,-0x5e00(%bp,%si)
  74:	00 a2 00 a2          	add    %ah,-0x5e00(%bp,%si)
  78:	00 a2 00 a2          	add    %ah,-0x5e00(%bp,%si)
  7c:	00 a2 00 a2          	add    %ah,-0x5e00(%bp,%si)
  80:	00 2f                	add    %ch,(%bx)
  82:	01 a2 00 60          	add    %sp,0x6000(%bp,%si)
  86:	1e                   	push   %ds
  87:	06                   	push   %es
  88:	0f a0                	push   %fs
  8a:	0f a8                	push   %gs
  8c:	66 31 c0             	xor    %eax,%eax
  8f:	67 8b 44 24 1e       	mov    0x1e(%eax,%eax,1),%ax
  94:	83 f8 21             	cmp    $0x21,%ax
  97:	73 09                	jae    0xa2
  99:	2e 67 ff 24 45       	jmp    *%cs:(%eax,%eax,1)
  9e:	43                   	inc    %bx
  9f:	00 00                	add    %al,(%bx,%si)
  a1:	00 0f                	add    %cl,(%bx)
  a3:	a9 0f a1             	test   $0xa10f,%ax
  a6:	07                   	pop    %es
  a7:	1f                   	pop    %ds
  a8:	61                   	popa   
  a9:	cf                   	iret   
  aa:	b8 00 03             	mov    $0x300,%ax
  ad:	31 db                	xor    %bx,%bx
  af:	e8 25 01             	call   0x1d7
  b2:	67 83 7c 24 1e 00    	cmpw   $0x0,0x1e(%eax,%eax,1)
  b8:	74 0c                	je     0xc6
  ba:	67 8b 4c 24 20       	mov    0x20(%eax,%eax,1),%cx
  bf:	67 c4 6c 24 22       	les    0x22(%eax,%eax,1),%bp
  c4:	eb 15                	jmp    0xdb
  c6:	67 c4 7c 24 20       	les    0x20(%eax,%eax,1),%di
  cb:	31 c9                	xor    %cx,%cx
  cd:	31 c0                	xor    %ax,%ax
  cf:	49                   	dec    %cx
  d0:	fc                   	cld    
  d1:	f2 ae                	repnz scas %es:(%di),%al
  d3:	41                   	inc    %cx
  d4:	01 cf                	add    %cx,%di
  d6:	f7 d9                	neg    %cx
  d8:	89 fd                	mov    %di,%bp
  da:	49                   	dec    %cx
  db:	b8 01 13             	mov    $0x1301,%ax
  de:	bb 1f 00             	mov    $0x1f,%bx
  e1:	e8 f3 00             	call   0x1d7
  e4:	eb bc                	jmp    0xa2
  e6:	b9 02 00             	mov    $0x2,%cx
  e9:	67 8a 54 24 20       	mov    0x20(%eax,%eax,1),%dl
  ee:	eb 13                	jmp    0x103
  f0:	b9 04 00             	mov    $0x4,%cx
  f3:	67 8b 54 24 20       	mov    0x20(%eax,%eax,1),%dx
  f8:	eb 09                	jmp    0x103
  fa:	b9 08 00             	mov    $0x8,%cx
  fd:	67 66 8b 54 24 20    	mov    0x20(%eax,%eax,1),%edx
 103:	b8 00 90             	mov    $0x9000,%ax
 106:	8e d8                	mov    %ax,%ds
 108:	8e c0                	mov    %ax,%es
 10a:	bf 08 00             	mov    $0x8,%di
 10d:	31 db                	xor    %bx,%bx
 10f:	fd                   	std    
 110:	88 d3                	mov    %dl,%bl
 112:	66 c1 ea 04          	shr    $0x4,%edx
 116:	80 e3 0f             	and    $0xf,%bl
 119:	2e 8a 87 b1 01       	mov    %cs:0x1b1(%bx),%al
 11e:	aa                   	stos   %al,%es:(%di)
 11f:	49                   	dec    %cx
 120:	75 ee                	jne    0x110
 122:	47                   	inc    %di
 123:	1e                   	push   %ds
 124:	57                   	push   %di
 125:	6a 00                	push   $0x0
 127:	cd 60                	int    $0x60
 129:	83 c4 06             	add    $0x6,%sp
 12c:	e9 73 ff             	jmp    0xa2
 12f:	31 db                	xor    %bx,%bx
 131:	31 c0                	xor    %ax,%ax
 133:	8e c0                	mov    %ax,%es
 135:	66 b9 ff 00 00 00    	mov    $0xff,%ecx
 13b:	26 67 83 3c 8d 02    	cmpw   $0x2,%es:(%eax,%eax,1)
 141:	00 00                	add    %al,(%bx,%si)
 143:	00 00                	add    %al,(%bx,%si)
 145:	74 64                	je     0x1ab
 147:	0e                   	push   %cs
 148:	68 c1 01             	push   $0x1c1
 14b:	6a 02                	push   $0x2
 14d:	6a 01                	push   $0x1
 14f:	cd 60                	int    $0x60
 151:	83 c4 08             	add    $0x8,%sp
 154:	51                   	push   %cx
 155:	6a 11                	push   $0x11
 157:	cd 60                	int    $0x60
 159:	83 c4 04             	add    $0x4,%sp
 15c:	0e                   	push   %cs
 15d:	68 c3 01             	push   $0x1c3
 160:	6a 01                	push   $0x1
 162:	6a 01                	push   $0x1
 164:	cd 60                	int    $0x60
 166:	83 c4 08             	add    $0x8,%sp
 169:	26 67 ff 34 8d       	pushw  %es:(%eax,%eax,1)
 16e:	02 00                	add    (%bx,%si),%al
 170:	00 00                	add    %al,(%bx,%si)
 172:	6a 12                	push   $0x12
 174:	cd 60                	int    $0x60
 176:	83 c4 04             	add    $0x4,%sp
 179:	0e                   	push   %cs
 17a:	68 c4 01             	push   $0x1c4
 17d:	6a 01                	push   $0x1
 17f:	6a 01                	push   $0x1
 181:	cd 60                	int    $0x60
 183:	83 c4 08             	add    $0x8,%sp
 186:	26 67 ff 34 8d       	pushw  %es:(%eax,%eax,1)
 18b:	00 00                	add    %al,(%bx,%si)
 18d:	00 00                	add    %al,(%bx,%si)
 18f:	6a 12                	push   $0x12
 191:	cd 60                	int    $0x60
 193:	83 c4 04             	add    $0x4,%sp
 196:	43                   	inc    %bx
 197:	83 fb 05             	cmp    $0x5,%bx
 19a:	7c 0f                	jl     0x1ab
 19c:	0e                   	push   %cs
 19d:	68 c5 01             	push   $0x1c5
 1a0:	6a 02                	push   $0x2
 1a2:	6a 01                	push   $0x1
 1a4:	cd 60                	int    $0x60
 1a6:	83 c4 08             	add    $0x8,%sp
 1a9:	31 db                	xor    %bx,%bx
 1ab:	49                   	dec    %cx
 1ac:	79 8d                	jns    0x13b
 1ae:	e9 f1 fe             	jmp    0xa2
 1b1:	30 31                	xor    %dh,(%bx,%di)
 1b3:	32 33                	xor    (%bp,%di),%dh
 1b5:	34 35                	xor    $0x35,%al
 1b7:	36                   	ss
 1b8:	37                   	aaa    
 1b9:	38 39                	cmp    %bh,(%bx,%di)
 1bb:	41                   	inc    %cx
 1bc:	42                   	inc    %dx
 1bd:	43                   	inc    %bx
 1be:	44                   	inc    %sp
 1bf:	45                   	inc    %bp
 1c0:	46                   	inc    %si
 1c1:	20 20                	and    %ah,(%bx,%si)
 1c3:	3d 3a 0d             	cmp    $0xd3a,%ax
 1c6:	0a 00                	or     (%bx,%si),%al
	...
 1d4:	00 00                	add    %al,(%bx,%si)
 1d6:	00 80 fc 03          	add    %al,0x3fc(%bx,%si)
 1da:	74 1e                	je     0x1fa
 1dc:	80 fc 04             	cmp    $0x4,%ah
 1df:	74 2c                	je     0x20d
 1e1:	80 fc 08             	cmp    $0x8,%ah
 1e4:	74 57                	je     0x23d
 1e6:	80 fc 0d             	cmp    $0xd,%ah
 1e9:	74 52                	je     0x23d
 1eb:	80 fc 0b             	cmp    $0xb,%ah
 1ee:	74 3a                	je     0x22a
 1f0:	80 fc 10             	cmp    $0x10,%ah
 1f3:	73 56                	jae    0x24b
 1f5:	60                   	pusha  
 1f6:	cd 10                	int    $0x10
 1f8:	61                   	popa   
 1f9:	c3                   	ret    
 1fa:	60                   	pusha  
 1fb:	1e                   	push   %ds
 1fc:	06                   	push   %es
 1fd:	cd 10                	int    $0x10
 1ff:	07                   	pop    %es
 200:	1f                   	pop    %ds
 201:	67 89 4c 24 0c       	mov    %cx,0xc(%eax,%eax,1)
 206:	67 89 54 24 0a       	mov    %dx,0xa(%eax,%eax,1)
 20b:	61                   	popa   
 20c:	c3                   	ret    
 20d:	60                   	pusha  
 20e:	1e                   	push   %ds
 20f:	06                   	push   %es
 210:	cd 10                	int    $0x10
 212:	07                   	pop    %es
 213:	1f                   	pop    %ds
 214:	67 89 44 24 0e       	mov    %ax,0xe(%eax,%eax,1)
 219:	67 89 5c 24 08       	mov    %bx,0x8(%eax,%eax,1)
 21e:	67 89 4c 24 0c       	mov    %cx,0xc(%eax,%eax,1)
 223:	67 89 54 24 0a       	mov    %dx,0xa(%eax,%eax,1)
 228:	61                   	popa   
 229:	c3                   	ret    
 22a:	60                   	pusha  
 22b:	1e                   	push   %ds
 22c:	06                   	push   %es
 22d:	cd 10                	int    $0x10
 22f:	07                   	pop    %es
 230:	1f                   	pop    %ds
 231:	67 89 44 24 0e       	mov    %ax,0xe(%eax,%eax,1)
 236:	67 89 5c 24 08       	mov    %bx,0x8(%eax,%eax,1)
 23b:	61                   	popa   
 23c:	c3                   	ret    
 23d:	60                   	pusha  
 23e:	1e                   	push   %ds
 23f:	06                   	push   %es
 240:	cd 10                	int    $0x10
 242:	07                   	pop    %es
 243:	1f                   	pop    %ds
 244:	67 89 44 24 0e       	mov    %ax,0xe(%eax,%eax,1)
 249:	61                   	popa   
 24a:	c3                   	ret    
 24b:	cd 10                	int    $0x10
 24d:	c3                   	ret    
	...
