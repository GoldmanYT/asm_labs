sseg		segment	stack	'stack'
		dw	256 dup(?)
sseg		ends

data		segment
string		db	7 dup(?)
num		dw	-32767
data		ends

code		segment
_start:		assume	cs:code,ds:data,ss:sseg
		extrn	short_to_str: near

		mov	ax,data
		mov	ds,ax

		mov	ax,seg string
		push	ax
		mov	ax,offset string
		push	ax
		mov	ax,num
		push	ax
		call	short_to_str

		mov	ax,4C00h
		int	21h
code		ends
		end	_start