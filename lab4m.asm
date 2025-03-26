data		segment
string		db	' some words  with spaces  ',0
char		db	' '
data		ends

code		segment
		assume	cs:code,ds:data
		extrn	word_count: near
_start:		mov	ax,data
		mov	ds,ax

		mov	al,char
		push	ax
		mov	ax,seg string
		push	ax
		mov	ax,offset string
		push	ax
		call	word_count

		mov	ax,4C00h
		int	21h
code		ends
		end	_start