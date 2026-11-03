# Krampus Sack Tracker

Mod client-side para Don't Starve Together. Exibe no HUD a direção aproximada e a distância do Krampus Sack mais próximo que o cliente consegue detectar.

## Instalação para teste

1. Baixe o repositório pelo botão **Code → Download ZIP**.
2. Extraia a pasta `KrampusSackTracker` para a pasta de mods do Don't Starve Together.
3. Ative o mod no menu de Mods do jogo.

## Como funciona

- Procura entidades com prefab `krampus_sack` presentes na tabela de entidades conhecida pelo cliente.
- Atualiza a indicação uma vez por segundo.
- Mostra uma seta de direção aproximada e a distância em unidades do jogo.
- Não exige que todos os jogadores tenham o mod instalado.

## Limitações

Este é um rastreador client-side, não um radar global. O cliente só consegue localizar entidades replicadas/conhecidas pela sua sessão. Portanto, não há garantia de detectar um saco em qualquer ponto do mundo, especialmente fora da área conhecida pelo cliente.

## Versão

0.1.1
