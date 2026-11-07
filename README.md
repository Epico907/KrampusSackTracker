# Klaus Loot Stash Tracker

Mod client-side para Don't Starve Together. Exibe no HUD a direção aproximada e a distância da Loot Stash (bolsa trancada) usada para invocar Klaus e da Deer Antler usada para abri-la.

## Instalação para teste

1. Baixe o repositório pelo botão **Code → Download ZIP**.
2. Extraia a pasta `KrampusSackTracker` para a pasta de mods do Don't Starve Together.
3. Ative o mod no menu de Mods do jogo.

## Como funciona

- Procura entidades com prefab `klaus_sack` (Loot Stash) e `deer_antler` (Deer Antler) presentes na tabela de entidades conhecida pelo cliente.
- Atualiza a indicação uma vez por segundo.
- Mostra uma seta de direção aproximada e a distância em unidades do jogo para cada item.
- Não rastreia Klaus diretamente nem a Krampus Sack que ele pode deixar cair.
- Não exige que todos os jogadores tenham o mod instalado.

## Limitações

Este é um rastreador client-side, não um radar global. O cliente só consegue localizar entidades replicadas/conhecidas pela sua sessão. Portanto, não há garantia de detectar a Loot Stash ou a Deer Antler em qualquer ponto do mundo, especialmente fora da área conhecida pelo cliente. Os itens precisam estar no mundo e replicados para o cliente; itens guardados no inventário de outro jogador não são localizados por esta busca.

## Versão

0.4.0
