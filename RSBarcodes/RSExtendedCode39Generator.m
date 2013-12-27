//
//  RSExtendedCode39Generator.m
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/26/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSExtendedCode39Generator.h"

NSString * const RSMetadataObjectTypeExtendedCode39Code = @"com.pdq.barcodes.code39.ext";

@implementation RSExtendedCode39Generator

/*
 
 ASCII	ENCODING	ASCII	ENCODING	ASCII	ENCODING	ASCII	ENCODING
 NUL	%U	SP	Space	@	%V	`	%W
 SOH	$A	!	/A	A	A	a	+A
 STX	$B	"	/B	B	B	b	+B
 ETX	$C	#	/C	C	C	c	+C
 EOT	$D	$	/D	D	D	d	+D
 ENQ	$E	%	/E	E	E	e	+E
 ACK	$F	&	/F	F	F	f	+F
 BEL	$G	'	/G	G	G	g	+G
 BS	$H	(	/H	H	H	H	H
 HT	$I	)	/I	I	I	i	+I
 LF	$J	*	/J	J	J	j	+J
 VT	$K	+	/K	K	K	k	+K
 FF	$L	,	/L	L	L	l	+L
 CR	$M	-	-	M	M	m	+M
 SO	$N	.	.	N	N	n	+N
 SI	$O	/	/O	O	O	o	+O
 DLE	$P	0	0	P	P	p	+P
 DC1	$Q	1	1	Q	Q	q	+Q
 DC2	$R	2	2	R	R	r	+R
 DC3	$S	3	3	S	S	s	+S
 DC4	$T	4	4	T	T	t	+T
 NAK	$U	5	5	U	U	u	+U
 SYN	$V	6	6	V	V	v	+V
 ETB	$W	7	7	W	W	w	+W
 CAN	$X	8	8	X	X	x	+X
 EM	$Y	9	9	Y	Y	y	+Y
 SUB	$Z	:	/Z	Z	Z	z	+Z
 ESC	%A	;	%F	[	%K	{	%P
 FS	%B	<<	%G	\	%L	|	%Q
 GS	%C	=	%H	]	%M	}	%R
 RS	%D	>	%I	^	%N	~	%S
 YS	%E	?	%J	_	%O	DEL	%T, %X, %Y, %Z
 */

- (NSString *)__encodeContents:(NSString *)contents
{
    NSMutableString *encoded = [[NSMutableString alloc] initWithString:@""];
    for (int i = 0; i < contents.length; i++) {
        NSString *character = [contents substringWithRange:NSMakeRange(i, 1)];
        char ch = [character UTF8String][0];
        switch (ch) {
            case 'a':
            case 'b':
            case 'c':
            case 'd':
            case 'e':
            case 'f':
            case 'g':
            case 'h':
            case 'i':
            case 'j':
            case 'k':
            case 'l':
            case 'm':
            case 'n':
            case 'o':
            case 'p':
            case 'q':
            case 'r':
            case 's':
            case 't':
            case 'u':
            case 'v':
            case 'w':
            case 'x':
            case 'y':
            case 'z':
                [encoded appendFormat:@"%@%@", @"+", [character uppercaseString]];
                break;
                
            case '!':
                [encoded appendFormat:@"%@%@", @"/", @"A"];
                break;
            case '"':
                [encoded appendFormat:@"%@%@", @"/", @"B"];
                break;
            case '#':
                [encoded appendFormat:@"%@%@", @"/", @"C"];
                break;
            case '$':
                [encoded appendFormat:@"%@%@", @"/", @"D"];
                break;
            case '%':
                [encoded appendFormat:@"%@%@", @"/", @"E"];
                break;
            case '&':
                [encoded appendFormat:@"%@%@", @"/", @"F"];
                break;
            case '\'':
                [encoded appendFormat:@"%@%@", @"/", @"G"];
                break;
            case '(':
                [encoded appendFormat:@"%@%@", @"/", @"H"];
                break;
            case ')':
                [encoded appendFormat:@"%@%@", @"/", @"I"];
                break;
            case '*':
                [encoded appendFormat:@"%@%@", @"/", @"J"];
                break;
            case '+':
                [encoded appendFormat:@"%@%@", @"/", @"K"];
                break;
            case ',':
                [encoded appendFormat:@"%@%@", @"/", @"L"];
                break;
                //                -                 /M   better to use -
                //                .                 /N   better to use .
            case '/':
                [encoded appendFormat:@"%@%@", @"/", @"O"];
                break;
                //                0                 /P   better to use 0
                //                1                 /Q   better to use 1
                //                2                 /R   better to use 2
                //                3                 /S   better to use 3
                //                4                 /T   better to use 4
                //                5                 /U   better to use 5
                //                6                 /V   better to use 6
                //                7                 /W   better to use 7
                //                8                 /X   better to use 8
                //                9                 /Y   better to use 9
            case ':':
                [encoded appendFormat:@"%@%@", @"/", @"Z"];
                break;
                
                //                ESC               %A
                //                FS                %B
                //                GS                %C
                //                RS                %D
                //                US                %E
            case ';':
                [encoded appendFormat:@"%@%@", @"%", @"F"];
                break;
            case '<':
                [encoded appendFormat:@"%@%@", @"%", @"G"];
                break;
            case '=':
                [encoded appendFormat:@"%@%@", @"%", @"H"];
                break;
            case '>':
                [encoded appendFormat:@"%@%@", @"%", @"I"];
                break;
            case '?':
                [encoded appendFormat:@"%@%@", @"%", @"J"];
                break;
            case '[':
                [encoded appendFormat:@"%@%@", @"%", @"K"];
                break;
            case '\\':
                [encoded appendFormat:@"%@%@", @"%", @"L"];
                break;
            case ']':
                [encoded appendFormat:@"%@%@", @"%", @"M"];
                break;
            case '^':
                [encoded appendFormat:@"%@%@", @"%", @"N"];
                break;
            case '_':
                [encoded appendFormat:@"%@%@", @"%", @"O"];
                break;
            case '{':
                [encoded appendFormat:@"%@%@", @"%", @"P"];
                break;
            case '|':
                [encoded appendFormat:@"%@%@", @"%", @"Q"];
                break;
            case '}':
                [encoded appendFormat:@"%@%@", @"%", @"R"];
                break;
            case '~':
                [encoded appendFormat:@"%@%@", @"%", @"S"];
                break;
                //                DEL               %T
                //                NUL               %U
            case '@':
                [encoded appendFormat:@"%@%@", @"%", @"V"];
                break;
            case '`':
                [encoded appendFormat:@"%@%@", @"%", @"W"];
                break;
                
                //                SOH               $A
                //                STX               $B
                //                ETX               $C
                //                EOT               $D
                //                ENQ               $E
                //                ACK               $F
                //                BEL               $G
                //                BS                $H
            case '\t':
                [encoded appendFormat:@"%@%@", @"$", @"I"];
                break;
                //                LF                $J
                //                VT                $K
                //                FF                $L
            case '\n':
                [encoded appendFormat:@"%@%@", @"$", @"M"];
                break;
                //                SO                $N
                //                SI                $O
                //                DLE               $P
                //                DC1               $Q
                //                DC2               $R
                //                DC3               $S
                //                DC4               $T
                //                NAK               $U
                //                SYN               $V
                //                ETB               $W
                //                CAN               $X
                //                EM                $Y
                //                SUB               $Z
                
            default:
                [encoded appendString:character];
                break;
        }
    }
    
    return [NSString stringWithString:encoded];
}

- (NSString *)barcode:(NSString *)contents
{
    return [super barcode:[self __encodeContents:contents]];
}

@end
