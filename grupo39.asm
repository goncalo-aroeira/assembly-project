;* Constantes
; **********************************************************************

DISPLAYS	EQU 0A000H	; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN         EQU 0C000H      ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL         EQU 0E000H      ; endereço das colunas do teclado (periférico PIN)
LINHA_TESTE     EQU 0001H       ; testar linha 1 (0001b)
MASCARA         EQU 000FH       ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

DEFINE_LINHA    EQU 600AH       ; endereço do comando para definir a linha
DEFINE_COLUNA   EQU 600CH       ; endereço do comando para definir a coluna
DEFINE_PIXEL    EQU 6012H       ; endereço do comando para escrever um pixel
DEFINE_FUNDO    EQU 6042H       ; endereço do comando para selecionar uma imagem de fundo
DEFINE_IMAGEM	EQU 6046H	; endereço do comando para selecionar uma imagem frontal
APAGA_AVISO     EQU 6040H       ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	EQU 6002H       ; endereço do comando para apagar todos os pixels já desenhados
TOCA_SOM	EQU 605AH       ; endereço do comando para tocar um som


TECLA_C         EQU 0081H	; "coordenadas" da tecla C no teclado
TECLA_D		EQU 0082H	; "coordenadas" da tecla D no teclado
TECLA_0		EQU 0011H	; "coordenadas" da tecla 0 no teclado
TECLA_1		EQU 0012H	; "coordenadas" da tecla 1 no teclado
TECLA_F		EQU 0088H	; "coordenadas" da tecla F no teclado
TECLA_B		EQU 0048H	; "coordenadas" da tecla B no teclado

LINHA_ROVER     EQU  28         ; linha do rover 
COLUNA_ROVER	EQU  30         ; coluna do rover 

LINHA_METEORO	EQU  0		; linha do meteoro
COLUNA_METEORO  EQU  30		; coluna do meteoro

LINHA_MISSIL	EQU  27		; linha do missil
MAX_MISSEL	EQU  12

MIN_COLUNA	EQU  0		; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA	EQU  63         ; número da coluna mais à direita que o objeto pode ocupar
ATRASO		EQU  400H	; atraso para limitar a velocidade de movimento do boneco

LARGURA_ROVER	EQU  5		; largura do 
ALTURA_ROVER   	EQU  4		; altura do rover
VERMELHO	EQU  0FF00H	; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)
VERDE		EQU  0F0F0H
AMARELO		EQU  0FFF0H
ROSA		EQU  0FF09H
AZUL		EQU  0F0FFH



; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       1000H

; Reserva do espaço para as pilhas dos processos
	STACK 100H		; espaço reservado para a pilha do processo "programa principal"
SP_inicial_prog_princ:		; este é o endereço com que o SP deste processo deve ser inicializado
							
	STACK 100H		; espaço reservado para a pilha do processo "teclado"
SP_inicial_teclado:		; este é o endereço com que o SP deste processo deve ser inicializado

	STACK 100H		; espaço reservado para a pilha do processo "rover"
SP_inicial_rover:		; este é o endereço com que o SP deste processo deve ser inicializado
	

	STACK 100H		; espaço reservado para a pilha do processo "meteoro"
SP_inicial_meteoro:		; este é o endereço com que o SP deste processo deve ser inicializado

	STACK 100H		; espaço reservado para a pilha do processo "displays"
SP_inicial_displays:		; este é o endereço com que o SP deste processo deve ser inicializado

	STACK 100H		; espaço reservado para a pilha do processo "modo_jogo"
SP_inicial_modo_jogo:		; este é o endereço com que o SP deste processo deve ser inicializado

	STACK 100H		; espaço reservado para a pilha do processo "missil"
SP_inicial_missil:		; este é o endereço com que o SP deste processo deve ser inicializado
	
	STACK 100H		; espaço reservado para a pilha do processo "testa_colisao"
SP_inicial_testa_colisao:	; este é o endereço com que o SP deste processo deve ser inicializado
	


tecla_carregada:
	LOCK 0			; LOCK para o teclado comunicar aos restantes processos que tecla detetou,
				; uma vez por cada tecla carregada
							
tecla_continuo:
	LOCK 0			; LOCK para o teclado comunicar aos restantes processos que tecla detetou,
				; enquanto a tecla estiver carregada

modo_de_jogo:			; LOCK para os processos saberem em que modo está o jogo (start, pause ou stop)
	LOCK 0		

							
evento_int_0:
	LOCK 0			; LOCK para a rotina de interrupção comunicar ao processo boneco que a interrupção ocorreu

evento_int_1:
	LOCK 0			; LOCK para a rotina de interrupção comunicar ao processo meteoro que a interrupção ocorreu

evento_int_2:
	LOCK 0			; LOCK para a rotina de interrupção comunicar ao processo meteoro que a interrupção ocorreu
	
	
contador_displays:
	WORD 	64H		; contador usado para mostrar nos displays

modo:				; variavel para saber em que modo de jogo estamos 0-ativo, 1-pausa e 2-parado
	WORD	0

missil_atinge:			; variavel para saber se o missil atingiu o meteoro ou nao
	WORD 0

disparo:			; variavel para saber quando o rover disparou
	WORD 0



coluna_missil:			; variável para saber em que coluna está o missil
	WORD 32

linha_missil:			; variável para saber em que linha está o missil
	WORD 27

coluna_rover:			; variável para saber em que coluna está o rover
	WORD 30	

linha_meteoro:			; variável para saber em que linha está o meteoro
	WORD 0	

pode_destruir:			; variável para saber se o rover pode ser destruído pelos destroços do meteoro
	WORD 0



; Tabela das rotinas de interrupção
tab:
	WORD rot_int_0			; rotina de atendimento da interrupção 0		
	WORD rot_int_1			; rotina de atendimento da interrupção 1	
	WORD rot_int_2			; rotina de atendimento da interrupção 2

			
DEF_BONECO:			; tabela que define o rover (cor, largura, altura, pixels)
	WORD	LARGURA_ROVER, ALTURA_ROVER
	WORD    0, 0, AMARELO, 0, 0
	WORD	AMARELO, 0, AMARELO, 0, AMARELO
	WORD    AMARELO, AMARELO, AMARELO, AMARELO , AMARELO
	WORD	0, AMARELO, 0, AMARELO, 0		
     

DEF_METEORO:			; tabela que define o meteoro maior
	WORD	LARGURA_ROVER, LARGURA_ROVER
	WORD	VERMELHO, 0, 0, 0, VERMELHO
	WORD	VERMELHO, 0, VERMELHO, 0, VERMELHO
	WORD	0, VERMELHO, VERMELHO, VERMELHO, 0
	WORD    VERMELHO, 0, VERMELHO, 0, VERMELHO
	WORD	VERMELHO, 0, 0, 0, VERMELHO

DEF_METEORO_1:			; tabela que define o meteoro mais pequeno
	WORD 	3, 3
	WORD	VERMELHO, 0, VERMELHO
	WORD	0, VERMELHO, 0
	WORD 	VERMELHO, 0, VERMELHO

DEF_METEORO_2:			; tabela que define o meteoro medio
	WORD	4, 4
	WORD 	VERMELHO, 0, 0, VERMELHO
	WORD	VERMELHO, 0, 0, VERMELHO
	WORD	0, VERMELHO, VERMELHO, 0
	WORD 	VERMELHO, 0, 0, VERMELHO	

DEF_MISSIL:			; tabela que define o missil
	WORD 1,1
	WORD ROSA

DEF_METEORO_DEST:		; tabela que define quando o meteoro é destruído
	WORD LARGURA_ROVER, LARGURA_ROVER
	WORD 0, AZUL, 0, AZUL, 0
	WORD AZUL, 0, AZUL, 0, AZUL
	WORD 0, AZUL, 0, AZUL, 0
	WORD AZUL, 0, AZUL, 0, AZUL
	WORD 0, AZUL, 0, AZUL, 0



; **********************************************************************
; * Código
; **********************************************************************

PLACE      0
inicio:		
; inicializações

reinicia:				; funçao para repor todos os valores das variáveis para os valores iniciais
	MOV R0, 64H
	MOV [contador_displays], R0

	MOV R0,1
	MOV [modo], R0

	MOV R0, 32
	MOV [coluna_missil], R0

	MOV R0, 27
	MOV [linha_missil], R0

	MOV R0, 32
	MOV [coluna_rover], R0
	
	MOV R0, 0
	MOV [linha_meteoro], R0
	MOV [pode_destruir], R0
	MOV [missil_atinge], R0
	MOV [disparo], R0


	MOV  SP, SP_inicial_prog_princ	; inicializa SP para a palavra a seguir à última da pilha
	
	MOV  BTE, tab			; inicializa BTE (registo de Base da Tabela de Exceções)	

	MOV  [APAGA_AVISO], R1	; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
        MOV  [APAGA_ECRÃ], R1	; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV  R1, 3              ; cenario de fundo numero 0
    	MOV  [DEFINE_FUNDO], R1 ; seleciona o cenario de fundo
	
	
	MOV  R9, DISPLAYS       ; endereço do periférico dos displays
	MOV R1, 100H		; valor para escrever nos displays
    	MOV [R9], R1      	; escreve o valor "100" nos displays


	
	EI0					; permite interrupções 0
	EI1
	EI2					; permite interrupções 2
	EI					; permite interrupções (geral)
						; a partir daqui, qualquer interrupção que ocorra usa
						; a pilha do processo que estiver a correr nessa altura
	
	
	CALL teclado		; cria o processo teclado
	CALL modo_jogo		; cria o processo modo_jogo



comeca_jogo:

	MOV R1, [tecla_carregada]	

	MOV R0, TECLA_C		; vê se a tecla "C" foi premida
	CMP R1, R0
	JNZ comeca_jogo
	

	MOV  R1, 0              ; cenario de fundo numero 0
    	MOV  [DEFINE_FUNDO], R1 ; seleciona o cenario de fundo
	MOV [modo], R1

	CALL boneco		; cria o processo boneco
	CALL meteoro		; cria o processo meteoro
	CALL displays		; cria o processo displays
	CALL missil		; cria o processo missil
	CALL testa_colisao	; cria o processo testa_colisao


		


; **********************************************************************
; ESPERA_TECLA - ciclo principal do programa em que fica à espera de um input (tecla)
;			que é guardado em R7 e consoante esse input executa a respetiva função
;
; **********************************************************************

espera_tecla:
    	
	MOV R1, [tecla_carregada]

    	JMP espera_tecla




; **********************************************************************
; Processo
;
; TECLADO - Processo que deteta quando se carrega numa tecla 
;		  do teclado e escreve o valor da tecla num LOCK.
;
; **********************************************************************

PROCESS SP_inicial_teclado	; indicação de que a rotina que se segue é um processo,
						; com indicação do valor para inicializar o SP

teclado:          		; neste ciclo espera-se até uma tecla ser premida

	MOV  R2, TEC_LIN	; endereço do periférico das linhas
    	MOV  R3, TEC_COL	; endereço do periférico das colunas
    	MOV  R5, MASCARA        ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
	MOV  R1, LINHA_TESTE 	; testar a linha 1

ciclo_teclado: 			; neste ciclo espera-se até uma tecla ser premida
	
	YIELD			; este ciclo é potencialmente bloqueante, pelo que tem de
					; ter um ponto de fuga (aqui pode comutar para outro processo)
	MOV R9, [linha_missil]
	
	MOV R4, R1

    	MOVB [R2], R1      	; escrever no periférico de saída (linhas)
    	MOVB R0, [R3]		; ler do periférico de entrada (colunas)
    	AND  R0, R5        	; elimina bits para além dos bits 0-3
    	CMP  R0, 0         	; há tecla premida?
    	JZ   muda_numero   	; se nenhuma tecla premida, repete
               
    
    	SHL  R1, 4         	; coloca linha no nibble high
    	OR   R1, R0        	; junta coluna (nibble low)
    	MOV [tecla_carregada], R1	; informa quem estiver bloqueado neste LOCK que uma tecla foi carregada
						; (o valor escrito é o número da coluna da tecla no teclado)
	
    
ha_tecla:              		; neste ciclo espera-se até NENHUMA tecla estar premida	

	YIELD				; este ciclo é potencialmente bloqueante, pelo que tem de
						; ter um ponto de fuga (aqui pode comutar para outro processo)

	MOV	[tecla_continuo], R1	; informa quem estiver bloqueado neste LOCK que uma tecla está a ser carregada
						; (o valor escrito é o número da coluna da tecla no teclado)
	MOV R1, R4

    	MOVB [R2], R1      	; escrever no periférico de saída (linhas)
    	MOVB R0, [R3]      	; ler do periférico de entrada (colunas)
    	AND  R0, R5        	; elimina bits para além dos bits 0-3
    	CMP  R0, 0         	; há tecla premida?
    	JNZ  muda	      	; se ainda houver uma tecla premida, espera até não haver

	JMP teclado		; esta "rotina" nunca retorna porque nunca termina
					; Se se quisesse terminar o processo, era deixar o processo chegar a um RET

muda:
	SHL  R1, 4         	; coloca linha no nibble high
    	OR   R1, R0        	; junta coluna (nibble low)
	JMP ha_tecla

	
muda_numero:
    	SHL R1, 1          	; avança para a proxima linha
    	MOV R0, 0010H
    	CMP R1, R0         	; vê se o valor é 0000b(não ha nenhuma linha)
    	JNZ ciclo_teclado       ; se for 0010H volta para a primeira linha
	
	JMP teclado




; **********************************************************************
; Processo
;
; BONECO - Processo que desenha um boneco e o move horizontalmente, com
;		 temporização marcada pela interrupção 0
;
; **********************************************************************

PROCESS SP_inicial_rover	; indicação de que a rotina que se segue é um processo,
						; com indicação do valor para inicializar o SP
boneco:					; processo que implementa o comportamento do boneco
	; desenha o boneco na sua posição inicial
     	MOV  R1, LINHA_ROVER		; linha do boneco
	MOV  R2, COLUNA_ROVER
	MOV  R4, DEF_BONECO		; endereço da tabela que define o boneco
ciclo_boneco:
	CALL	desenha_boneco		; desenha o boneco a partir da tabela
espera_movimento:
	MOV	R3, [tecla_continuo]	; lê o LOCK e bloqueia até o teclado escrever nele novamente
	
	MOV R0, [modo]			; vê se o modo é o "parado" e se for não executa o resto do processo
	CMP R0, 1
	JZ espera_movimento
	
	MOV 	R0, TECLA_0		; verifica se foi a tecla "0" foi premida
	CMP	R3, R0		
	JZ 	move_esquerda

	MOV 	R0, TECLA_1		; verifica se foi a tecla "1" foi premida
	CMP     R3, R0
	JZ 	move_direita

	JMP	ciclo_boneco	; se não é, ignora e continua à espera

	

move_esquerda:			; função que move o rover para a esquerda
	MOV R8, -1		; valor a subtrair à coluna do rover

	JMP ve_limites		; vê se o rover não passa dos limites do ecrã


move_direita:			; função que move o rover para a direita
	MOV R8, 1		; valor a somar à coluna do rover

	JMP ve_limites		; vê se o rover não passa dos limites do ecrã


ve_limites:
	MOV  R6, [R4]		; obtém a largura do boneco
	CALL testa_limites	; vê se chegou aos limites do ecrã e se sim força R7 a 0
	CMP  R8, 0
	JZ   ciclo_boneco	; se não é para movimentar o objeto, vai ler o teclado de novo

move_boneco:			; função que vai simular o movimento do boneco
	MOV R5, [coluna_missil]	
	ADD R5, R8
	MOV [coluna_missil], R5	; atualiza a nova coluna em que o missil vai ser disparado
	CALL  apaga_boneco	; apaga o boneco na sua posição corrente


coluna_seguinte:		; função que desenha o rover na nova coluna
	ADD	R2, R8		; para desenhar objeto na coluna seguinte (direita ou esquerda)
	
	MOV [coluna_rover], R2	; atualiza a coluna do rover

	JMP	ciclo_boneco	; vai desenhar o boneco de novo



; **********************************************************************
; ROT_INT_0 - 	Rotina de atendimento da interrupção 0
;			Faz simplesmente uma escrita no LOCK que o processo boneco lê.
;			Como basta indicar que a interrupção ocorreu (não há mais
;			informação a transmitir), basta a escrita em si, pelo que
;			o registo usado, bem como o seu valor, é irrelevante
; **********************************************************************
rot_int_0:
	MOV	[evento_int_0], R0	; desbloqueia processo boneco (qualquer registo serve) 
	RFE


; **********************************************************************
; Processo
;
; METEORO - Processo que desenha um boneco e o move verticalmente, com
;		 temporização marcada pela interrupção 0
;
; **********************************************************************

PROCESS SP_inicial_meteoro		; indicação de que a rotina que se segue é um processo,
						; com indicação do valor para inicializar o SP
meteoro:					; processo que implementa o comportamento do boneco
	; desenha o boneco na sua posição inicial
     	MOV  R1, LINHA_METEORO		; linha do meteoro
	MOV  R2, COLUNA_METEORO		; coluna do meteoro
	MOV  R4, DEF_METEORO_1		; endereço da tabela que define o meteoro
ciclo_meteoro:
	CALL	desenha_boneco		; desenha o boneco a partir da tabela

espera_movimento_meteoro:
	MOV R3, [evento_int_0]		; lê o LOCK e bloqueia até a interrupção escrever nele novamente

	MOV R3, [modo]			; verifica se o modo de jogo não é o "parado"
	CMP R3, 1
	JZ espera_movimento_meteoro

	MOV R3, [pode_destruir]		; vê se o meteoro já foi destruido para não o voltar a desenhar
	CMP R3, 1
	JZ destroi


move_meteoro:			; função que move o meteoro uma linha para baixo
	
	MOV  R8, 1			; valor a somar à linha do meteoro	
	
	CALL apaga_boneco	; apaga o boneco na sua posição corrente

	MOV  R9, 001FH
	CMP  R1, R9		; ver se o meteoro não está na última linha
	JZ espera_movimento_meteoro	; desenha o boneco na nova linha

	
escolhe_meteoro: 
	MOV R1, [linha_meteoro]

	CMP R1, 5		; se o meteoro estiver antes da linha 5 desenha o pequeno
	JLE meteoro_pequeno
	
	MOV R3, 10		; se o meteoro estiver depois da linha 10 desenha o grande
	CMP R1, R3
	JGE meteoro_grande

	JMP meteoro_medio	; se o meteoro estiver entre as duas linhas desenha o medio
	
desenha_meteoro:
	ADD  R1, R8		; linha em que o meteoro vai começar a ser desenhado
	MOV [linha_meteoro], R1	; atualiza a linha do meteoro
	CALL desenha_boneco     ; desenha o meteoro na nova linha
	JMP espera_movimento_meteoro

destroi:
	CALL apaga_boneco
	JMP espera_movimento_meteoro

meteoro_pequeno:		; função para escolher o meteoro pequeno para ser desenhado
	MOV R4, DEF_METEORO_1	
	JMP desenha_meteoro

meteoro_medio:			; função para escolher o meteoro medio para ser desenhado
	MOV R4, DEF_METEORO_2
	JMP desenha_meteoro

meteoro_grande:			; função para escolher o meteoro grande para ser desenhado
	MOV R4, DEF_METEORO
	JMP desenha_meteoro	


; **********************************************************************
; ROT_INT_1 - 	Rotina de atendimento da interrupção 0
;			Faz simplesmente uma escrita no LOCK que o processo boneco lê.
;			Como basta indicar que a interrupção ocorreu (não há mais
;			informação a transmitir), basta a escrita em si, pelo que
;			o registo usado, bem como o seu valor, é irrelevante
; **********************************************************************
rot_int_1:
	MOV	[evento_int_1], R0	; desbloqueia processo missil (qualquer registo serve) 
	RFE



; **********************************************************************
; Processo
;
; MISSIL - Processo que "dispara" o missil, com temporização marcada pela interrupção 
;
; **********************************************************************

PROCESS SP_inicial_missil

missil:
	MOV R3, [tecla_carregada]

	MOV R1, [modo]			; verifica se o modo de jogo não é o "parado"
	CMP R1, 1
	JZ missil

	MOV R0, TECLA_D			; vê quando é que é premida a tecla "D"
	CMP R3, R0
	JNZ missil
	
	MOV  R1, LINHA_MISSIL		; linha do missil
	MOV  R2, [coluna_missil]	; coluna do missil
	MOV  R4, DEF_MISSIL		; endereço da tabela que define o missil

	MOV  R9, 0			; som com número 0
	MOV  [TOCA_SOM], R9		; comando para tocar o som

	MOV R0, 1
	MOV [disparo], R0		; missil foi disparado e vai consumir energia
	
	MOV R0, MAX_MISSEL

int_missil:
	MOV R3, [evento_int_1]		; lê o LOCK e bloqueia até a interrupção escrever nele novamente

	CALL apaga_boneco		; apaga o missil na posição atual
	SUB R1, 1			; passa para a linha seguinte
	CALL desenha_boneco		; desenha o missil na nova linha
		
	MOV [linha_missil], R1		; atualiza a linha do missil
	
	SUB R0, 1			; vê se já chegou à linha limite de diparo do meteoro
	CMP R0, 0
	JNZ int_missil

	CALL apaga_boneco		; se já tiver chegado o meteoro desaparece

	JMP missil




; **********************************************************************
; ROT_INT_2 - 	Rotina de atendimento da interrupção 0
;			Faz simplesmente uma escrita no LOCK que o processo boneco lê.
;			Como basta indicar que a interrupção ocorreu (não há mais
;			informação a transmitir), basta a escrita em si, pelo que
;			o registo usado, bem como o seu valor, é irrelevante
; **********************************************************************
rot_int_2:
	MOV	[evento_int_2], R0	; desbloqueia processo displays (qualquer registo serve) 
	RFE



; **********************************************************************
; Processo
;
; DISPLAYS - Processo que altera o valor dos displays, com temporização marcada pela interrupção 
;
; **********************************************************************

PROCESS SP_inicial_displays

displays:
	MOV R1, [evento_int_2]		; lê o LOCK e bloqueia até a interrupção escrever nele novamente
	
	MOV R1, [modo]			; verifica se o modo de jogo não é o "parado"
	CMP R1, 1
	JZ displays
	

primeiro:

	MOV R1, DISPLAYS	; endereço periférico dos displays
	MOV R2, [contador_displays]
	MOV R3, 03E8H		; começamos o nosso fator com 1000
	MOV R4, 000AH		 
	MOV R7, 0000H	

	MOV R0, [missil_atinge]	; vê se o missil atingiu um meteoro para ganhar energia
	CMP R0, 1
	JZ missil_atingiu

	MOV R0, [disparo]	; vê se o rover disparou algum missil e tira energia
	CMP R0, 1
	JZ rover_disparou

	SUB R2, 0005H
	
transforma_decimal:			; função que transforma o valor do display em decimal
	MOV [contador_displays], R2	; atualiza o valor da variável global

	MOD R2, R3 		; fazemos o resto da divisão pelo fator
	PUSH R2			; guardamos o valor do número a ser utilizado na próxima iteração

	DIV R3, R4		; alteramos o valor do fator
	DIV R2, R3		; mais um dígito do valor decimal

	SHL R7, 4		; desloca, para dar espaço ao novo dígito
	OR  R7, R2		; vai compondo o resultado
	
	POP R2

	CMP R3, R4
	JLT  escrever_valor	; se o fator for menor que 10, está completo

	JMP transforma_decimal	; repete
	
escrever_valor:

	MOV [R1], R7		; escrevem o novo valor nos displays
	
	CMP R7, 0
	JNZ displays

	JMP inicio


missil_atingiu:			; se houve um missil que atingiu um meteoro vai ganhar 10% de energia
	MOV R0, 0
	MOV [missil_atinge], R0
	ADD R2, R4
	JMP transforma_decimal

rover_disparou:			; se um missil foi disparado para além dos 5% de energia que perde ao longo do tempo, perde mais 5% devido ao disparo
	MOV R0, 0
	MOV [disparo], R0
	SUB R2, R4
	JMP transforma_decimal


aumenta_display:               	; função para aumentar o valor do display	

	MOV R1, DISPLAYS	; endereço periférico dos displays
	MOV R2, [contador_displays]	
	ADD R2, 0001H 		; adiciona 0001H à variavel global
	MOV [R1], R2		; escrevem o novo valor nos displays
	MOV [contador_displays], R2	; atualiza o valor da variável global

	JMP displays





; **********************************************************************
; Processo
;
; MODO_JOGO - Processo que altera o valor dos displays, com temporização marcada pela interrupção 
;
; **********************************************************************

PROCESS SP_inicial_modo_jogo

modo_jogo:
	MOV R1, [tecla_carregada]

	MOV R0, TECLA_B		
	CMP R1, R0		; vê se a tecla B foi premida
	JZ para_jogo

	MOV R0, TECLA_C		
	CMP R1, R0		; vê se a tecla C foi premida
	JZ continua_jogo
	
	JMP modo_jogo

para_jogo:			; função que vai parar o jogo
	
	MOV R1,1
	MOV [DEFINE_IMAGEM], R1	; define a nova imagem de fundo

	MOV [modo], R1		; atualiza a variável modo de jogo

	JMP modo_jogo

continua_jogo:			; função para continuar o jogo
	MOV R1,0
	MOV [DEFINE_IMAGEM], R1	; define a nova imagem de fudo

	MOV [modo], R1		; atualiza a variável modo de jogo

	JMP modo_jogo
	




; **********************************************************************
; Processo
;
; TESTA_COLISAO - Processo que testa se houve colisao entre o meteoro e algum outro objeto 
;
; **********************************************************************


PROCESS SP_inicial_testa_colisao

testa_colisao:
	
	YIELD

missil_e_meteoro:
	MOV  R1, [linha_meteoro]	; linha do meteoro
	MOV  R2, COLUNA_METEORO		; coluna do meteoro
	MOV  R4, DEF_METEORO		; endereço da tabela que define o meteoro
	
	MOV R0, [linha_missil]
	MOV R3, [coluna_missil]

	PUSH R4
	MOV  R6, [R4]		; obtém a largura do meteoro
	ADD R4, 2
	MOV R5, [R4]		; obtema a altura do meteoro
	POP R4
	
	ADD R1, R5		; vai para a última linha do meteoro
	SUB R1, 1


testa_linha_missil:			; se estiver numa das mesmas colunas que o meteoro vai verificar a linha
	
	CMP R1, R0		; vê se a linha do missil é igual à linha do meteoro
	JNZ rover_e_meteoro


testa_coluna_missil:	
	CMP R3, R2		; ve se a coluna atual do missil está à esquerda do meteoro
	JLT rover_e_meteoro	
	
	ADD R2, R6		; vai para a coluna mais à direita do meteoro
	CMP R3, R2		; ve se a coluna atual do missil está à direita do meteoro
	JGT rover_e_meteoro

	MOV R0, 1
	MOV [missil_atinge], R0

	MOV  R9, 1			; som com número 1
	MOV  [TOCA_SOM], R9		; comando para tocar o som


destroi_meteoro:		; função que é usada para simular a destruição do meteoro
	MOV  R1, [linha_meteoro]	; linha do meteoro
	MOV  R2, COLUNA_METEORO		; coluna do meteoro
	MOV  R4, DEF_METEORO		; endereço da tabela que define o meteoro
	
	CALL apaga_boneco	; apaga o meteoro

	MOV R4, DEF_METEORO_DEST	; tabela que vai desenhar o meteoro já destruido
	CALL desenha_boneco

	MOV R0, 1
	MOV [pode_destruir], R0		; saber se o rover pode ser destruido
	JMP testa_colisao



rover_e_meteoro:
	MOV  R1, [linha_meteoro]	; linha do meteoro
	MOV  R2, COLUNA_METEORO		; coluna do meteoro
	
	MOV  R4, LINHA_ROVER		; linha do boneco
	MOV  R5, [coluna_rover]
	
	ADD R1, R6		; vai para a última linha do meteoro
	SUB R1, 1



testa_linha_rover:
	SUB R4, 2
	CMP R1, R4
	JNZ testa_colisao

testa_coluna_rover:
	
	ADD R5, R6		; vai para a coluna mais à direita do rover
	CMP R5, R2		; vai comparar a coluna mais à esquerda do meteoro com a coluna mais à direita do rover
	JLE testa_colisao	
	
	ADD R2, R6		; vai para a coluna mais à direita do meteoro
	SUB R5, R6		; vai para a coluna mais à esquerda do rover
	CMP R5, R2		; vai comparar a coluna mais à esquerda do rover com a coluna mais à direita do meteoro
	JGE testa_colisao

	MOV  R9, 1			; som com número 1
	MOV  [TOCA_SOM], R9		; comando para tocar o som


destroi_rover:			; função que é usada para simular a destruição do rover

	MOV R0, 3	
	MOV  [APAGA_ECRÃ], R0	; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV [DEFINE_FUNDO], R0	; define o novo fundo de ecrã

	MOV R0, 1		; passa o jogo para o modo parado
	MOV [modo], R0	
	JMP inicio







; **********************************************************************
; DESENHA_BONECO - Desenha um boneco na linha e coluna indicadas
;			    com a forma e cor definidas na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R3 - tabela que define o boneco
;
; **********************************************************************
desenha_boneco:
	PUSH    R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH    R6
	PUSH    R7
	PUSH    R9
	MOV	R5, [R4]	; obtém a largura do boneco
	ADD     R4, 2		; endereço da altura
	MOV     R6, R5          ; guarda uma copia da largura
	MOV     R3, [R4]	; obtém a altura do boneco
	ADD	R4, 2		; endereço da cor do 1º pixel (2 porque a largura é uma word)
	MOV     R7, R2		; guarda uma cópia da primeira coluna do boneco

desenha_pixels:       		; desenha os pixels do boneco a partir da tabela
	MOV	R9, [R4]	; obtém a cor do próximo pixel do boneco
	CALL	escreve_pixel	; escreve cada pixel do boneco
	ADD	R4, 2		; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
     	ADD     R2, 1           ; próxima coluna
      	SUB     R5, 1		; menos uma coluna para tratar
     	JNZ  desenha_pixels     ; continua até percorrer toda a largura do objeto
	MOV     R5, R6		; repõe a largura do boneco
	MOV     R2, R7		; volta para a primeira coluna onde o boneco é desenhado
	ADD     R1, 1		; próxima linha
	SUB     R3, 1		; menos uma linha para tratar
	JNZ  desenha_pixels	; continua até percorrer toda a altura do boneco
	POP     R9
	POP     R7
	POP     R6
	POP	R5
	POP	R4
	POP	R3
	POP	R2
	POP     R1
	RET



; **********************************************************************
; ESCREVE_PIXEL - Escreve um pixel na linha e coluna indicadas.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R3 - cor do pixel (em formato ARGB de 16 bits)
;
; **********************************************************************
escreve_pixel:
	MOV  [DEFINE_LINHA], R1		; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R9		; altera a cor do pixel na linha e coluna já selecionadas
	RET




; **********************************************************************
; APAGA_BONECO - Apaga um boneco na linha e coluna indicadas
;			  com a forma definida na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R3 - tabela que define o boneco
;
; **********************************************************************

apaga_boneco:
	PUSH    R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH    R6
	PUSH    R7
	PUSH    R9
	MOV	R5, [R4]	; obtém a largura do boneco
	MOV     R6, R5		; guarda uma cópia da largura
	ADD     R4, 2		; endereço da altura
	MOV     R3, [R4]	; obtém a altura do boneco
	ADD	R4, 2		; endereço da cor do 1º pixel (2 porque a largura é uma word)
	MOV     R7, R2		; guarda uma cópia da primeira coluna do boneco

apaga_pixels:       		; desenha os pixels do boneco a partir da tabela
	MOV	R9, 0		; cor para apagar o próximo pixel do boneco
	CALL	escreve_pixel	; escreve cada pixel do boneco
	ADD	R4, 2		; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
     	ADD     R2, 1           ; próxima coluna
     	SUB     R5, 1		; menos uma coluna para tratar
     	JNZ     apaga_pixels  	; continua até percorrer toda a largura do objeto
	MOV     R5, R6		; repõe a largura do boneco
	MOV     R2, R7		; volta para a primeira coluna onde o boneco é desenhado
	ADD     R1, 1		; próxima linha
	SUB     R3, 1		; menos uma linha para tratar
	JNZ     apaga_pixels	; continua até percorrer a altura toda do boneco
	POP	R9
	POP     R7
	POP     R6
	POP	R5
	POP	R4
	POP	R3
	POP	R2
	POP     R1
	RET




; **********************************************************************
; TESTA_LIMITES - Testa se o boneco chegou aos limites do ecrã e nesse caso
;			   impede o movimento (força R7 a 0)
; Argumentos:	R2 - coluna em que o objeto está
;			R6 - largura do boneco
;			R7 - sentido de movimento do boneco (valor a somar à coluna
;				em cada movimento: +1 para a direita, -1 para a esquerda)
;
; Retorna: 	R7 - 0 se já tiver chegado ao limite, inalterado caso contrário	
; **********************************************************************

testa_limites:
	PUSH	R5
	PUSH	R6
testa_limite_esquerdo:			; vê se o boneco chegou ao limite esquerdo
	MOV	R5, MIN_COLUNA
	CMP	R2, R5
	JGT	testa_limite_direito
	CMP	R8, 0			; passa a deslocar-se para a direita
	JGE	sai_testa_limites
	JMP	impede_movimento	; entre limites. Mantém o valor do R7
testa_limite_direito:			; vê se o boneco chegou ao limite direito
	ADD	R6, R2			; posição a seguir ao extremo direito do boneco
	MOV	R5, MAX_COLUNA
	CMP	R6, R5
	JLE	sai_testa_limites	; entre limites. Mantém o valor do R7
	CMP	R8, 0			; passa a deslocar-se para a direita
	JGT	impede_movimento
	JMP	sai_testa_limites
impede_movimento:
	MOV	R8, 0			; impede o movimento, forçando R7 a 0
sai_testa_limites:	
	POP	R6
	POP	R5
	RET


	


	



	





