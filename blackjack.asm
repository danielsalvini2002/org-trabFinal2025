#José de Bortoli - 2121101041
#Daniel Salvini - 2021101024

.data                                    # Início da seção de dados (variáveis)
# Mensagens do jogo
MSG_BJ: .asciz "Bem-vindo ao Blackjack!\n"  # Define string para mensagem de boas-vindas
MSG_CARTAS: .asciz "Total de Cartas: 52\n"  # Define string informando total de cartas
MSG_PONTUACAO: .asciz "Pontuacao:\n"       # Define string para mostrar pontuação
MSG_DEALER: .asciz "Dealer: 0\n"            # Define string para pontuação inicial do dealer
MSG_JOGADOR: .asciz "Jogador: 0\n"         # Define string para pontuação inicial do jogador
MSG_JOGAR: .asciz "Quer jogar? (1 - Sim, 2 - Nao): " # Define string para perguntar se quer jogar
MSG_RECEBE: .asciz "O jogador recebe: "     # Define string para mostrar carta recebida pelo jogador
MSG_DEALER_REVELA: .asciz "O dealer revela: " # Define string para mostrar carta revelada pelo dealer
MSG_CARTA_OCULTA: .asciz " e uma carta oculta\n" # Define string para carta não revelada do dealer
MSG_SUA_MAO: .asciz "Sua mao: "            # Define string para mostrar mão do jogador
MSG_MAIS: .asciz " + "                     # Define string para separador de cartas
MSG_IGUAL: .asciz " = "                    # Define string para mostrar resultado da soma
MSG_OPCOES: .asciz "O que quer fazer? (1 - Hit, 2 - Stand): " # Define string para opções do jogador
MSG_DEALER_REVELA_TUDO: .asciz "O dealer revela sua mao: " # Define string para revelação completa do dealer
MSG_DEALER_CONTINUA: .asciz "O dealer deve continuar pedindo cartas...\n" # Define string para quando dealer pede mais cartas
MSG_DEALER_ESTOUROU: .asciz "O dealer estourou! Voce venceu!\n" # Define string para quando dealer estoura
MSG_JOGADOR_ESTOUROU: .asciz "Voce estourou! O dealer venceu!\n" # Define string para quando jogador estoura
MSG_VITORIA_JOGADOR: .asciz "Voce ganhou!\n" # Define string para vitória do jogador
MSG_VITORIA_DEALER: .asciz "O dealer ganhou!\n" # Define string para vitória do dealer
MSG_EMPATE: .asciz "Empatou!\n"              # Define string para empate

# Variáveis
cartas_jogador: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Array para armazenar até 10 cartas do jogador
cartas_dealer: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0   # Array para armazenar até 10 cartas do dealer
num_cartas_jogador: .word 0                   # Contador de cartas do jogador
num_cartas_dealer: .word 0                    # Contador de cartas do dealer
soma_jogador: .word 0                         # Soma dos valores das cartas do jogador
soma_dealer: .word 0                          # Soma dos valores das cartas do dealer
jogador_estourou: .word 0                     # Flag que indica se o jogador estourou (0=não, 1=sim)
dealer_estourou: .word 0                      # Flag que indica se o dealer estourou (0=não, 1=sim)

.text                                    # Início da seção de código
.globl main                                  # Declara 'main' como ponto de entrada global

main:                                    # Função principal do programa
    # Salvar ra na pilha, pois main chama outras funções
    addi sp, sp, -4
    sw ra, 0(sp)

    # Exibir mensagem de boas-vindas
    la a0, MSG_BJ                        # Carrega endereço da mensagem de boas-vindas em a0
    li a7, 4                             # Carrega o código 4 em a7 (syscall para imprimir string)
    ecall                                # Executa a syscall
    
    la a0, MSG_CARTAS                    # Carrega endereço da mensagem de cartas em a0
    li a7, 4                             # Carrega o código 4 em a7 (syscall para imprimir string)
    ecall                                # Executa a syscall
    
    la a0, MSG_PONTUACAO                 # Carrega endereço da mensagem de pontuação em a0
    li a7, 4                             # Carrega o código 4 em a7 (syscall para imprimir string)
    ecall                                # Executa a syscall
    
    la a0, MSG_DEALER                    # Carrega endereço da mensagem do dealer em a0
    li a7, 4                             # Carrega o código 4 em a7 (syscall para imprimir string)
    ecall                                # Executa a syscall
    
    la a0, MSG_JOGADOR                   # Carrega endereço da mensagem do jogador em a0
    li a7, 4                             # Carrega o código 4 em a7 (syscall para imprimir string)
    ecall                                # Executa a syscall
    
    # Perguntar se deseja jogar
    la a0, MSG_JOGAR                     # Carrega endereço da mensagem de pergunta em a0
    li a7, 4                             # Carrega o código 4 em a7 (syscall para imprimir string)
    ecall                                # Executa a syscall
    
    # Ler opção do usuário
    li a7, 5                             # Carrega o código 5 em a7 (syscall para ler inteiro)
    ecall                                # Executa a syscall
    li t0, 1                             # Carrega o valor 1 em t0 para comparação
    bne a0, t0, fim_jogo                 # Se a resposta não for 1, pula para fim_jogo
    
    # Iniciar uma nova rodada
    call nova_rodada                     # Chama a função nova_rodada
    
    # Distribuir cartas iniciais
    call distribuir_cartas_iniciais      # Chama a função distribuir_cartas_iniciais
    
    # Mostrar cartas do jogador
    la a0, MSG_RECEBE                    # Carrega endereço da mensagem de recebimento em a0
    li a7, 4                             # Carrega o código 4 em a7 (syscall para imprimir string)
    ecall                                # Executa a syscall
    
    la t0, cartas_jogador                # Carrega endereço do array de cartas do jogador em t0
    lw a0, 0(t0)                         # Carrega o valor da primeira carta em a0
    li a7, 1                             # Carrega o código 1 em a7 (syscall para imprimir inteiro)
    ecall                                # Executa a syscall
    
    li a0, ' '                           # Carrega o caractere espaço em a0
    li a7, 11                            # Carrega o código 11 em a7 (syscall para imprimir caractere)
    ecall                                # Executa a syscall
    
    la t0, cartas_jogador                # Carrega endereço do array de cartas do jogador em t0
    lw a0, 4(t0)                         # Carrega o valor da segunda carta em a0
    li a7, 1                             # Carrega o código 1 em a7 (syscall para imprimir inteiro)
    ecall                                # Executa a syscall
    
    li a0, '\n'                          # Carrega o caractere nova linha em a0
    li a7, 11                            # Carrega o código 11 em a7 (syscall para imprimir caractere)
    ecall                                # Executa a syscall
    
    # Mostrar cartas do dealer (apenas uma visível)
    la a0, MSG_DEALER_REVELA            # Carrega endereço da mensagem de revelação do dealer em a0
    li a7, 4                             # Carrega o código 4 em a7 (syscall para imprimir string)
    ecall                                # Executa a syscall
    
    la t0, cartas_dealer                 # Carrega endereço do array de cartas do dealer em t0
    lw a0, 0(t0)                         # Carrega o valor da primeira carta em a0
    li a7, 1                             # Carrega o código 1 em a7 (syscall para imprimir inteiro)
    ecall                                # Executa a syscall
    
    la a0, MSG_CARTA_OCULTA             # Carrega endereço da mensagem de carta oculta em a0
    li a7, 4                             # Carrega o código 4 em a7 (syscall para imprimir string)
    ecall                                # Executa a syscall
    
    # Calcular soma inicial do jogador
    call calcular_soma_jogador           # Chama a função calcular_soma_jogador
    
    # Mostrar soma do jogador
    la a0, MSG_SUA_MAO                   # Carrega endereço da mensagem "Sua mão" em a0
    li a7, 4                             # Carrega o código 4 em a7 (syscall para imprimir string)
    ecall                                # Executa a syscall
    
    la t0, cartas_jogador                # Carrega endereço do array de cartas do jogador em t0
    lw a0, 0(t0)                         # Carrega o valor da primeira carta em a0
    li a7, 1                             # Carrega o código 1 em a7 (syscall para imprimir inteiro)
    ecall                                # Executa a syscall
    
    la a0, MSG_MAIS                     # Carrega endereço da mensagem "+" em a0
    li a7, 4                             # Carrega o código 4 em a7 (syscall para imprimir string)
    ecall                                # Executa a syscall
    
    la t0, cartas_jogador                # Carrega endereço do array de cartas do jogador em t0
    lw a0, 4(t0)                         # Carrega o valor da segunda carta em a0
    li a7, 1                             # Carrega o código 1 em a7 (syscall para imprimir inteiro)
    ecall                                # Executa a syscall
    
    la a0, MSG_IGUAL                    # Carrega endereço da mensagem "=" em a0
    li a7, 4                             # Carrega o código 4 em a7 (syscall para imprimir string)
    ecall                                # Executa a syscall
    
    la t0, soma_jogador                  # Carrega endereço da variável soma_jogador em t0
    lw a0, 0(t0)                         # Carrega o valor da soma em a0
    li a7, 1                             # Carrega o código 1 em a7 (syscall para imprimir inteiro)
    ecall                                # Executa a syscall
    
    li a0, '\n'                          # Carrega o caractere nova linha em a0
    li a7, 11                            # Carrega o código 11 em a7 (syscall para imprimir caractere)
    ecall                                # Executa a syscall
    
    # Loop do jogador
    loop_jogador:                        # Início do loop para as ações do jogador
        # Perguntar ação do jogador
        la a0, MSG_OPCOES               # Carrega endereço da mensagem de opções em a0
        li a7, 4                         # Carrega o código 4 em a7 (syscall para imprimir string)
        ecall                                # Executa a syscall
        
        # Ler opção do jogador
        li a7, 5                         # Carrega o código 5 em a7 (syscall para ler inteiro)
        ecall                                # Executa a syscall
        
        li t0, 1                         # Carrega o valor 1 em t0 para comparação (Hit)
        beq a0, t0, jogador_hit          # Se a opção for 1, pula para jogador_hit
        li t0, 2                         # Carrega o valor 2 em t0 para comparação (Stand)
        beq a0, t0, jogador_stand        # Se a opção for 2, pula para jogador_stand
        j loop_jogador                   # Se nenhuma opção válida, volta ao início do loop
        
        jogador_hit:                     # Jogador escolheu pedir mais uma carta
            # Distribuir nova carta para o jogador
            call distribuir_carta_jogador   # Chama a função distribuir_carta_jogador
            
            # Calcular nova soma
            call calcular_soma_jogador      # Chama a função calcular_soma_jogador
            
            # Verificar se estourou
            la t0, soma_jogador             # Carrega endereço da variável soma_jogador em t0
            lw t0, 0(t0)                     # Carrega o valor da soma em t0
            li t1, 21                        # Carrega o valor 21 em t1 para comparação
            bgt t0, t1, jogador_estourou_label # Se soma > 21, pula para jogador_estourou_label
            
            # Mostrar nova carta e soma
            la a0, MSG_RECEBE               # Carrega endereço da mensagem de recebimento em a0
            li a7, 4                         # Carrega o código 4 em a7 (syscall para imprimir string)
            ecall                                # Executa a syscall
            
            la t0, num_cartas_jogador       # Carrega endereço da variável num_cartas_jogador em t0
            lw t0, 0(t0)                     # Carrega o número de cartas em t0
            addi t0, t0, -1                 # Subtrai 1 para obter o índice da última carta
            slli t0, t0, 2                   # Multiplica por 4 (tamanho de word) para obter o offset
            la t1, cartas_jogador           # Carrega endereço do array de cartas do jogador em t1
            add t1, t1, t0                   # Adiciona o offset ao endereço base
            lw a0, 0(t1)                     # Carrega o valor da última carta em a0
            li a7, 1                         # Carrega o código 1 em a7 (syscall para imprimir inteiro)
            ecall                                # Executa a syscall
            
            li a0, '\n'                      # Carrega o caractere nova linha em a0
            li a7, 11                        # Carrega o código 11 em a7 (syscall para imprimir caractere)
            ecall                                # Executa a syscall
            
            la a0, MSG_SUA_MAO              # Carrega endereço da mensagem "Sua mão" em a0
            li a7, 4                         # Carrega o código 4 em a7 (syscall para imprimir string)
            ecall                                # Executa a syscall
            
            # Mostrar todas as cartas e soma
            li t2, 0                         # Inicializa o contador com 0
            la t0, num_cartas_jogador       # Carrega endereço da variável num_cartas_jogador em t0
            lw t3, 0(t0)                     # Carrega o número de cartas em t3
            la t4, cartas_jogador           # Carrega endereço do array de cartas do jogador em t4
            mostrar_cartas_loop:            # Início do loop para mostrar todas as cartas
                beq t2, t3, mostrar_soma    # Se contador == número de cartas, pula para mostrar_soma
                
                slli t5, t2, 2               # Multiplica contador por 4 para obter offset
                add t6, t4, t5               # Adiciona offset ao endereço base
                lw a0, 0(t6)                 # Carrega o valor da carta em a0
                li a7, 1                     # Carrega o código 1 em a7 (syscall para imprimir inteiro)
                ecall                            # Executa a syscall
                
                addi t2, t2, 1               # Incrementa contador
                beq t2, t3, mostrar_soma    # Se contador == número de cartas, pula para mostrar_soma
                
                la a0, MSG_MAIS             # Carrega endereço da mensagem "+" em a0
                li a7, 4                     # Carrega o código 4 em a7 (syscall para imprimir string)
                ecall                            # Executa a syscall
                
                j mostrar_cartas_loop       # Volta ao início do loop
                
            mostrar_soma:                   # Mostra a soma total das cartas
                la a0, MSG_IGUAL            # Carrega endereço da mensagem "=" em a0
                li a7, 4                     # Carrega o código 4 em a7 (syscall para imprimir string)
                ecall                            # Executa a syscall
                
                la t0, soma_jogador         # Carrega endereço da variável soma_jogador em t0
                lw a0, 0(t0)                 # Carrega o valor da soma em a0
                li a7, 1                     # Carrega o código 1 em a7 (syscall para imprimir inteiro)
                ecall                            # Executa a syscall
                
                li a0, '\n'                  # Carrega o caractere nova linha em a0
                li a7, 11                    # Carrega o código 11 em a7 (syscall para imprimir caractere)
                ecall                            # Executa a syscall
                
                j loop_jogador              # Volta ao início do loop do jogador
                
        jogador_estourou_label:             # Jogador estourou (soma > 21)
            li t0, 1                         # Carrega o valor 1 em t0
            la t1, jogador_estourou         # Carrega endereço da variável jogador_estourou em t1
            sw t0, 0(t1)                     # Armazena 1 na variável (marca como estourado)
            j fim_rodada                     # Pula para fim_rodada
            
        jogador_stand:                      # Jogador escolheu parar
            j loop_dealer                    # Pula para o loop do dealer
    
    # Loop do dealer
    loop_dealer:                         # Início do loop para as ações do dealer
        # Calcular soma do dealer
        call calcular_soma_dealer       # Chama a função calcular_soma_dealer
        
        # Verificar se deve continuar
        la t0, soma_dealer              # Carrega endereço da variável soma_dealer em t0
        lw t0, 0(t0)                     # Carrega o valor da soma em t0
        li t1, 17                        # Carrega o valor 17 em t1 para comparação
        blt t0, t1, dealer_hit           # Se soma < 17, pula para dealer_hit
        j verificar_vencedor             # Senão, pula para verificar_vencedor
        
        dealer_hit:                      # Dealer deve pedir mais uma carta
            # Mostrar que o dealer está pedindo mais cartas
            la a0, MSG_DEALER_CONTINUA   # Carrega endereço da mensagem de continuação em a0
            li a7, 4                     # Carrega o código 4 em a7 (syscall para imprimir string)
            ecall                            # Executa a syscall
            
            # Distribuir nova carta para o dealer
            call distribuir_carta_dealer   # Chama a função distribuir_carta_dealer
            
            # Calcular nova soma
            call calcular_soma_dealer      # Chama a função calcular_soma_dealer
            
            # Verificar se estourou
            la t0, soma_dealer             # Carrega endereço da variável soma_dealer em t0
            lw t0, 0(t0)                     # Carrega o valor da soma em t0
            li t1, 21                        # Carrega o valor 21 em t1 para comparação
            bgt t0, t1, dealer_estourou_label # Se soma > 21, pula para dealer_estourou_label
            
            j loop_dealer                  # Volta ao início do loop do dealer
            
        dealer_estourou_label:            # Dealer estourou (soma > 21)
            li t0, 1                         # Carrega o valor 1 em t0
            la t1, dealer_estourou          # Carrega endereço da variável dealer_estourou em t1
            sw t0, 0(t1)                     # Armazena 1 na variável (marca como estourado)
            j fim_rodada                     # Pula para fim_rodada
    
    # Verificar quem ganhou
    verificar_vencedor:                  # Verifica quem ganhou a rodada
        la t0, soma_jogador             # Carrega endereço da variável soma_jogador em t0
        lw t0, 0(t0)                     # Carrega o valor da soma do jogador em t0
        la t1, soma_dealer              # Carrega endereço da variável soma_dealer em t1
        lw t1, 0(t1)                     # Carrega o valor da soma do dealer em t1
        
        beq t0, t1, empate               # Se somas iguais, pula para empate
        bgt t0, t1, jogador_vence        # Se soma do jogador > soma do dealer, pula para jogador_vence
        j dealer_vence                   # Senão, pula para dealer_vence
        
        empate:                         # Resultado: empate
            la a0, MSG_EMPATE           # Carrega endereço da mensagem de empate em a0
            li a7, 4                     # Carrega o código 4 em a7 (syscall para imprimir string)
            ecall                            # Executa a syscall
            j fim_rodada                # Pula para fim_rodada
            
        jogador_vence:                  # Resultado: jogador vence
            la a0, MSG_VITORIA_JOGADOR  # Carrega endereço da mensagem de vitória do jogador em a0
            li a7, 4                     # Carrega o código 4 em a7 (syscall para imprimir string)
            ecall                            # Executa a syscall
            j fim_rodada                # Pula para fim_rodada
            
        dealer_vence:                   # Resultado: dealer vence
            la a0, MSG_VITORIA_DEALER   # Carrega endereço da mensagem de vitória do dealer em a0
            li a7, 4                     # Carrega o código 4 em a7 (syscall para imprimir string)
            ecall                            # Executa a syscall
            j fim_rodada                # Pula para fim_rodada
    
    fim_rodada:                          # Finalização da rodada
        # Mostrar mão completa do dealer
        la a0, MSG_DEALER_REVELA_TUDO   # Carrega endereço da mensagem de revelação em a0
        li a7, 4                     # Carrega o código 4 em a7 (syscall para imprimir string)
        ecall                            # Executa a syscall
        
        li t2, 0                         # Inicializa o contador com 0
        la t0, num_cartas_dealer        # Carrega endereço da variável num_cartas_dealer em t0
        lw t3, 0(t0)                     # Carrega o número de cartas em t3
        la t4, cartas_dealer            # Carrega endereço do array de cartas do dealer em t4
        mostrar_cartas_dealer_loop:     # Início do loop para mostrar todas as cartas do dealer
            beq t2, t3, mostrar_soma_dealer # Se contador == número de cartas, pula para mostrar_soma_dealer
            
            slli t5, t2, 2               # Multiplica contador por 4 para obter offset
            add t6, t4, t5               # Adiciona offset ao endereço base
            lw a0, 0(t6)                 # Carrega o valor da carta em a0
            li a7, 1                     # Carrega o código 1 em a7 (syscall para imprimir inteiro)
            ecall                            # Executa a syscall
            
            addi t2, t2, 1               # Incrementa contador
            beq t2, t3, mostrar_soma_dealer # Se contador == número de cartas, pula para mostrar_soma_dealer
            
            la a0, MSG_MAIS             # Carrega endereço da mensagem "+" em a0
            li a7, 4                     # Carrega o código 4 em a7 (syscall para imprimir string)
            ecall                            # Executa a syscall
            
            j mostrar_cartas_dealer_loop # Volta ao início do loop
            
        mostrar_soma_dealer:            # Mostra a soma total das cartas do dealer
            la a0, MSG_IGUAL            # Carrega endereço da mensagem "=" em a0
            li a7, 4                     # Carrega o código 4 em a7 (syscall para imprimir string)
            ecall                            # Executa a syscall
            
            la t0, soma_dealer          # Carrega endereço da variável soma_dealer em t0
            lw a0, 0(t0)                 # Carrega o valor da soma em a0
            li a7, 1                     # Carrega o código 1 em a7 (syscall para imprimir inteiro)
            ecall                            # Executa a syscall
            
            li a0, '\n'                  # Carrega o caractere nova linha em a0
            li a7, 11                    # Carrega o código 11 em a7 (syscall para imprimir caractere)
            ecall                            # Executa a syscall
            
        # Verificar se alguém estourou
        la t0, jogador_estourou         # Carrega endereço da variável jogador_estourou em t0
        lw t0, 0(t0)                     # Carrega o valor da flag em t0
        bnez t0, jogador_perdeu_estouro # Se flag != 0, pula para jogador_perdeu_estouro
        
        la t0, dealer_estourou          # Carrega endereço da variável dealer_estourou em t0
        lw t0, 0(t0)                     # Carrega o valor da flag em t0
        bnez t0, dealer_perdeu_estouro  # Se flag != 0, pula para dealer_perdeu_estouro
        j fim_jogo                       # Senão, pula para fim_jogo
        
        jogador_perdeu_estouro:         # Mostra mensagem de jogador estourado
            la a0, MSG_JOGADOR_ESTOUROU # Carrega endereço da mensagem de jogador estourado em a0
            li a7, 4                     # Carrega o código 4 em a7 (syscall para imprimir string)
            ecall                            # Executa a syscall
            j fim_jogo                  # Pula para fim_jogo
            
        dealer_perdeu_estouro:          # Mostra mensagem de dealer estourado
            la a0, MSG_DEALER_ESTOUROU   # Carrega endereço da mensagem de dealer estourado em a0
            li a7, 4                     # Carrega o código 4 em a7 (syscall para imprimir string)
            ecall                            # Executa a syscall
            j fim_jogo                  # Pula para fim_jogo
    
    fim_jogo:                            # Finalização do jogo
        # Restaurar ra da pilha antes de sair de main
        lw ra, 0(sp)
        addi sp, sp, 4
        
        li a7, 10                        # Carrega o código 10 em a7 (syscall para terminar programa)
        ecall                                # Executa a syscall

# Funções do jogo
nova_rodada:                             # Função para iniciar uma nova rodada
    # Reiniciar variáveis da rodada
    la t0, num_cartas_jogador            # Carrega endereço da variável num_cartas_jogador em t0
    sw zero, 0(t0)                       # Zera o número de cartas do jogador
    la t0, num_cartas_dealer             # Carrega endereço da variável num_cartas_dealer em t0
    sw zero, 0(t0)                       # Zera o número de cartas do dealer
    la t0, soma_jogador                  # Carrega endereço da variável soma_jogador em t0
    sw zero, 0(t0)                       # Zera a soma do jogador
    la t0, soma_dealer                   # Carrega endereço da variável soma_dealer em t0
    sw zero, 0(t0)                       # Zera a soma do dealer
    la t0, jogador_estourou              # Carrega endereço da variável jogador_estourou em t0
    sw zero, 0(t0)                       # Zera a flag de jogador estourado
    la t0, dealer_estourou               # Carrega endereço da variável dealer_estourou em t0
    sw zero, 0(t0)                       # Zera a flag de dealer estourado
    
    # Limpar cartas do jogador e dealer
    li t0, 0                             # Inicializa contador com 0
    la t1, cartas_jogador                # Carrega endereço do array de cartas do jogador em t1
    li t2, 10                            # Carrega o valor 10 em t2 (número máximo de cartas)
    limpar_jogador:                      # Loop para limpar array de cartas do jogador
        sw zero, 0(t1)                   # Zera a posição atual
        addi t1, t1, 4                   # Avança para próxima posição (offset de 4 bytes)
        addi t0, t0, 1                   # Incrementa contador
        blt t0, t2, limpar_jogador       # Se contador < 10, continua loop
        
    li t0, 0                             # Reinicializa contador com 0
    la t1, cartas_dealer                 # Carrega endereço do array de cartas do dealer em t1
    li t2, 10                            # Carrega o valor 10 em t2 (número máximo de cartas)
    limpar_dealer:                       # Loop para limpar array de cartas do dealer
        sw zero, 0(t1)                   # Zera a posição atual
        addi t1, t1, 4                   # Avança para próxima posição (offset de 4 bytes)
        addi t0, t0, 1                   # Incrementa contador
        blt t0, t2, limpar_dealer        # Se contador < 10, continua loop
    
    ret                                  # Retorna da função

distribuir_cartas_iniciais:              # Função para distribuir as cartas iniciais
    # Salvar ra na pilha, pois chama dealerDistribution
    addi sp, sp, -4
    sw ra, 0(sp)

    # Distribuir 2 cartas para o jogador
    call dealerDistribution              # Chama a função dealerDistribution
    la t0, num_cartas_jogador            # Carrega endereço da variável num_cartas_jogador em t0
    lw t0, 0(t0)                         # Carrega o número de cartas em t0
    slli t1, t0, 2                       # Multiplica por 4 (tamanho de word) para obter o offset
    la t2, cartas_jogador               # Carrega endereço do array de cartas do jogador em t2
    add t2, t2, t1                       # Adiciona o offset ao endereço base
    sw a0, 0(t2)                         # Armazena a carta na posição correta
    addi t0, t0, 1                       # Incrementa o número de cartas
    la t1, num_cartas_jogador            # Carrega endereço da variável num_cartas_jogador em t1
    sw t0, 0(t1)                         # Atualiza o número de cartas do jogador
    
    call dealerDistribution              # Chama a função dealerDistribution
    la t0, num_cartas_jogador            # Carrega endereço da variável num_cartas_jogador em t0
    lw t0, 0(t0)                         # Carrega o número de cartas em t0
    slli t1, t0, 2                       # Multiplica por 4 (tamanho de word) para obter o offset
    la t2, cartas_jogador               # Carrega endereço do array de cartas do jogador em t2
    add t2, t2, t1                       # Adiciona o offset ao endereço base
    sw a0, 0(t2)                         # Armazena a carta na posição correta
    addi t0, t0, 1                       # Incrementa o número de cartas
    la t1, num_cartas_jogador            # Carrega endereço da variável num_cartas_jogador em t1
    sw t0, 0(t1)                         # Atualiza o número de cartas do jogador
    
    # Distribuir 2 cartas para o dealer
    call dealerDistribution              # Chama a função dealerDistribution
    la t0, num_cartas_dealer             # Carrega endereço da variável num_cartas_dealer em t0
    lw t0, 0(t0)                         # Carrega o número de cartas em t0
    slli t1, t0, 2                       # Multiplica por 4 (tamanho de word) para obter o offset
    la t2, cartas_dealer                # Carrega endereço do array de cartas do dealer em t2
    add t2, t2, t1                       # Adiciona o offset ao endereço base
    sw a0, 0(t2)                         # Armazena a carta na posição correta
    addi t0, t0, 1                       # Incrementa o número de cartas
    la t1, num_cartas_dealer             # Carrega endereço da variável num_cartas_dealer em t1
    sw t0, 0(t1)                         # Atualiza o número de cartas do dealer
    
    call dealerDistribution              # Chama a função dealerDistribution
    la t0, num_cartas_dealer             # Carrega endereço da variável num_cartas_dealer em t0
    lw t0, 0(t0)                         # Carrega o número de cartas em t0
    slli t1, t0, 2                       # Multiplica por 4 (tamanho de word) para obter o offset
    la t2, cartas_dealer                # Carrega endereço do array de cartas do dealer em t2
    add t2, t2, t1                       # Adiciona o offset ao endereço base
    sw a0, 0(t2)                         # Armazena a carta na posição correta
    addi t0, t0, 1                       # Incrementa o número de cartas
    la t1, num_cartas_dealer             # Carrega endereço da variável num_cartas_dealer em t1
    sw t0, 0(t1)                         # Atualiza o número de cartas do dealer
    
    # Restaurar ra da pilha
    lw ra, 0(sp)
    addi sp, sp, 4
    ret                                  # Retorna da função

distribuir_carta_jogador:                # Função para distribuir uma carta para o jogador
    # Salvar ra na pilha, pois chama dealerDistribution
    addi sp, sp, -4
    sw ra, 0(sp)

    call dealerDistribution              # Chama a função dealerDistribution
    la t0, num_cartas_jogador            # Carrega endereço da variável num_cartas_jogador em t0
    lw t0, 0(t0)                         # Carrega o número de cartas em t0
    slli t1, t0, 2                       # Multiplica por 4 (tamanho de word) para obter o offset
    la t2, cartas_jogador               # Carrega endereço do array de cartas do jogador em t2
    add t2, t2, t1                       # Adiciona o offset ao endereço base
    sw a0, 0(t2)                         # Armazena a carta na posição correta
    addi t0, t0, 1                       # Incrementa o número de cartas
    la t1, num_cartas_jogador            # Carrega endereço da variável num_cartas_jogador em t1
    sw t0, 0(t1)                         # Atualiza o número de cartas do jogador
    
    # Restaurar ra da pilha
    lw ra, 0(sp)
    addi sp, sp, 4
    ret                                  # Retorna da função

distribuir_carta_dealer:                 # Função para distribuir uma carta para o dealer
    # Salvar ra na pilha, pois chama dealerDistribution
    addi sp, sp, -4
    sw ra, 0(sp)

    call dealerDistribution              # Chama a função dealerDistribution
    la t0, num_cartas_dealer             # Carrega endereço da variável num_cartas_dealer em t0
    lw t0, 0(t0)                         # Carrega o número de cartas em t0
    slli t1, t0, 2                       # Multiplica por 4 (tamanho de word) para obter o offset
    la t2, cartas_dealer                # Carrega endereço do array de cartas do dealer em t2
    add t2, t2, t1                       # Adiciona o offset ao endereço base
    sw a0, 0(t2)                         # Armazena a carta na posição correta
    addi t0, t0, 1                       # Incrementa o número de cartas
    la t1, num_cartas_dealer             # Carrega endereço da variável num_cartas_dealer em t1
    sw t0, 0(t1)                         # Atualiza o número de cartas do dealer
    
    # Restaurar ra da pilha
    lw ra, 0(sp)
    addi sp, sp, 4
    ret                                  # Retorna da função

calcular_soma_jogador:                   # Função para calcular a soma das cartas do jogador
    li t0, 0                             # Zera o registrador t0 (usado para soma)
    li t1, 0                             # Zera o registrador t1 (contador de cartas)
    la t2, num_cartas_jogador            # Carrega endereço da variável num_cartas_jogador em t2
    lw t2, 0(t2)                         # Carrega o número de cartas em t2
    la t3, cartas_jogador                # Carrega endereço do array de cartas do jogador em t3
    
    soma_loop_jogador:                   # Início do loop para calcular a soma
        beq t1, t2, fim_soma_jogador     # Se contador == número de cartas, sai do loop
        
        slli t4, t1, 2                   # Multiplica contador por 4 para obter offset
        add t5, t3, t4                   # Adiciona offset ao endereço base
        lw t6, 0(t5)                     # Carrega o valor da carta em t6
        
        # Converter valor da carta para pontos
        li t4, 1                         # Carrega o valor 1 em t4 para comparação
        beq t6, t4, as_jogador           # Se carta == 1, vai para as_jogador
        li t4, 11                        # Carrega o valor 11 em t4 para comparação
        beq t6, t4, figura_jogador       # Se carta == 11 (ou figura), vai para figura_jogador
        li t4, 12                        # Carrega o valor 12 em t4 para comparação
        beq t6, t4, figura_jogador       # Se carta == 12 (ou figura), vai para figura_jogador
        li t4, 13                        # Carrega o valor 13 em t4 para comparação
        beq t6, t4, figura_jogador       # Se carta == 13 (ou figura), vai para figura_jogador
        
        # Cartas numeradas (2-10)
        add t0, t0, t6                   # Adiciona o valor da carta à soma
        j proxima_carta_jogador          # Pula para o processamento da próxima carta
        
        as_jogador:                      # Processamento especial para o Ás
            # Verificar se pode valer 11 sem estourar
            addi t4, t0, 11              # Adiciona 11 à soma atual
            li t5, 21                    # Carrega o valor 21 em t5 para comparação
            ble t4, t5, as_11_jogador    # Se soma + 11 <= 21, vai para as_11_jogador
            # Se não, vale 1
            addi t0, t0, 1               # Adiciona 1 à soma
            j proxima_carta_jogador      # Pula para o processamento da próxima carta
            
            as_11_jogador:               # Ás contando como 11
                addi t0, t0, 11          # Adiciona 11 à soma
                j proxima_carta_jogador  # Pula para o processamento da próxima carta
                
        figura_jogador:                  # Processamento para figuras (J, Q, K)
            addi t0, t0, 10              # Adiciona 10 à soma
            j proxima_carta_jogador      # Pula para o processamento da próxima carta
            
        proxima_carta_jogador:           # Processamento da próxima carta
            addi t1, t1, 1               # Incrementa o contador de cartas
            j soma_loop_jogador          # Volta ao início do loop de soma
            
    fim_soma_jogador:                    # Fim do cálculo da soma do jogador
        la t1, soma_jogador              # Carrega endereço da variável soma_jogador em t1
        sw t0, 0(t1)                     # Armazena o valor da soma
        ret                                  # Retorna da função

calcular_soma_dealer:                    # Função para calcular a soma das cartas do dealer
    li t0, 0                             # Zera o registrador t0 (usado para soma)
    li t1, 0                             # Zera o registrador t1 (contador de cartas)
    la t2, num_cartas_dealer             # Carrega endereço da variável num_cartas_dealer em t2
    lw t2, 0(t2)                         # Carrega o número de cartas em t2
    la t3, cartas_dealer                 # Carrega endereço do array de cartas do dealer em t3
    
    soma_loop_dealer:                    # Início do loop para calcular a soma
        beq t1, t2, fim_soma_dealer      # Se contador == número de cartas, sai do loop
        
        slli t4, t1, 2                   # Multiplica contador por 4 para obter offset
        add t5, t3, t4                   # Adiciona offset ao endereço base
        lw t6, 0(t5)                     # Carrega o valor da carta em t6
        
        # Converter valor da carta para pontos
        li t4, 1                         # Carrega o valor 1 em t4 para comparação
        beq t6, t4, as_dealer            # Se carta == 1, vai para as_dealer
        li t4, 11                        # Carrega o valor 11 em t4 para comparação
        beq t6, t4, figura_dealer        # Se carta == 11 (ou figura), vai para figura_dealer
        li t4, 12                        # Carrega o valor 12 em t4 para comparação
        beq t6, t4, figura_dealer        # Se carta == 12 (ou figura), vai para figura_dealer
        li t4, 13                        # Carrega o valor 13 em t4 para comparação
        beq t6, t4, figura_dealer        # Se carta == 13 (ou figura), vai para figura_dealer
        
        # Cartas numeradas (2-10)
        add t0, t0, t6                   # Adiciona o valor da carta à soma
        j proxima_carta_dealer           # Pula para o processamento da próxima carta
        
        as_dealer:                       # Processamento especial para o Ás
            # Verificar se pode valer 11 sem estourar
            addi t4, t0, 11              # Adiciona 11 à soma atual
            li t5, 21                    # Carrega o valor 21 em t5 para comparação
            ble t4, t5, as_11_dealer     # Se soma + 11 <= 21, vai para as_11_dealer
            # Se não, vale 1
            addi t0, t0, 1               # Adiciona 1 à soma
            j proxima_carta_dealer       # Pula para o processamento da próxima carta
            
            as_11_dealer:                # Ás contando como 11
                addi t0, t0, 11          # Adiciona 11 à soma
                j proxima_carta_dealer   # Pula para o processamento da próxima carta
                
        figura_dealer:                   # Processamento para figuras (J, Q, K)
            addi t0, t0, 10              # Adiciona 10 à soma
            j proxima_carta_dealer       # Pula para o processamento da próxima carta
            
        proxima_carta_dealer:            # Processamento da próxima carta
            addi t1, t1, 1               # Incrementa o contador de cartas
            j soma_loop_dealer           # Volta ao início do loop de soma
            
    fim_soma_dealer:                     # Fim do cálculo da soma do dealer
        la t1, soma_dealer               # Carrega endereço da variável soma_dealer em t1
        sw t0, 0(t1)                     # Armazena o valor da soma
        ret                                  # Retorna da função

# Função que gera uma carta aleatória entre 1 e 13
dealerDistribution:
    li a0, 0
    li a1, 13  # limite superior (inclusivo)
    li a7, 42  # chamada de sistema para random int range
    ecall
    addi a0, a0, 1  # ajusta para 1-13
    ret
