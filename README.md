# Blackjack - Simulador em Assembly RISC-V

## Descrição
Este projeto implementa um jogo de Blackjack (21) em Assembly RISC-V como trabalho final da disciplina de Organização de Computadores. O jogo simula uma partida de Blackjack entre o jogador e o dealer (computador), seguindo as regras clássicas do jogo.

## Autores
- José de Bortoli - 2121101041
- Daniel Salvini - 2021101024

## Requisitos do Sistema
- Simulador RISC-V (RARS 1.6)
- Java Runtime Environment (JRE)
- Windows Subsystem for Linux (WSL) ou ambiente Linux

## Instalação do RARS
Para executar o projeto no WSL, siga os passos abaixo:

```bash
# Baixar o RARS
wget https://github.com/TheThirdOne/rars/releases/download/v1.6/rars1_6.jar

# Instalar dependências gráficas
sudo apt install libx11-xcb1 libglu1-mesa

# Executar o RARS
java -jar rars1_6.jar
```

## Como Jogar
1. Após abrir o RARS, carregue o arquivo `blackjack.asm` usando File > Open
2. Compile o código usando Run > Assemble
3. Execute o programa usando Run > Go
4. Siga as instruções na tela para jogar:
   - Digite 1 para iniciar um jogo
   - Durante o jogo, digite 1 para pedir mais uma carta (Hit) ou 2 para parar (Stand)
   - Observe o resultado e veja se ganhou do dealer!

## Regras Implementadas
- O jogo usa um baralho padrão (valores de 1 a 13, onde 1 é Ás e 11-13 são as figuras)
- O jogador e o dealer recebem duas cartas no início
- Apenas uma carta do dealer é revelada inicialmente
- O jogador pode pedir mais cartas (Hit) ou parar (Stand)
- O dealer deve pedir cartas até atingir pelo menos 17 pontos
- Ases podem valer 1 ou 11 pontos (o programa escolhe o valor mais vantajoso)
- Figuras (J, Q, K) valem 10 pontos
- Quem ultrapassar 21 pontos "estoura" e perde
- Se ninguém estourar, ganha quem tiver mais pontos

## Estrutura do Projeto
```
org-trabFinal/
├── blackjack.asm    # Código fonte do jogo
└── README.md        # Este arquivo
```

## Funcionalidades
- Geração aleatória de cartas
- Cálculo automático de pontuação (incluindo tratamento especial para Ases)
- Interface de texto para interação com o usuário
- Sistema de decisão para o dealer baseado nas regras do Blackjack
- Verificação de condições de vitória, derrota e empate

## Implementação
O projeto foi implementado usando Assembly RISC-V, com foco em:
- Uso de registradores para manipulação eficiente de dados
- Estruturas de dados para armazenar cartas e pontuações
- Uso de chamadas de sistema (ecall) para entrada/saída
- Implementação de funções modulares para as diferentes partes do jogo
- Manipulação de arrays para armazenar as cartas de cada jogador
- Algoritmos para calcular pontuações considerando as regras específicas do Blackjack

## Detalhes Técnicos
- O programa utiliza a seção `.data` para armazenar mensagens e variáveis
- As cartas são geradas aleatoriamente usando a syscall 42 (random int range)
- Arrays são usados para armazenar até 10 cartas para cada jogador
- Funções específicas calculam a pontuação considerando as regras especiais (Ases e figuras)
- O programa implementa verificações para todas as condições de jogo (estouros, vitórias, empates)

## Tecnologias Utilizadas
- Assembly RISC-V
- RARS (RISC-V Assembler and Runtime Simulator)
- Syscalls para entrada/saída e geração de números aleatórios

## Solução de Problemas
Se encontrar problemas ao executar no WSL com interface gráfica:
- Certifique-se de ter um servidor X instalado (como VcXsrv para Windows)
- Configure a variável de ambiente: `export DISPLAY=:0`
- Para problemas de renderização, tente: `export LIBGL_ALWAYS_INDIRECT=1`

---

**Nota:** Este projeto foi desenvolvido para fins educacionais como parte da disciplina de Organização de Computadores.