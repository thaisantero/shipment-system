# SISTEMA DE FRETE

Esta aplicação é responsável por gerenciar a frota de entrega para um e-commerce com alcance nacional. Diferentes tipos de transporte são cadastrados definindo, os quais apresentam custos distintos. A plataforma cadastra novos pedidos de frete (ordens de serviço) e faz os cálculos de frete de acordo com os tipos de transporte que atendem ao perfil do pedido. Além disso, a aplicação controla as ordens de serviço em andamento, encerra ordens de serviço e apresenta o status da frota de veículos da empresa.

Fluxograma com escopo da aplicação está aqui:
https://excalidraw.com/#json=DdOGmgVFqHn75iQKISZNn,2Uwvx369cEgJvcfCe__9Cw

Link do Trello com organização das tarefas está aqui:
https://trello.com/b/XXovEVX4/sistema-de-frete-treinadev

Para utilizar esta aplicação, é necessário realizar os seguintes comandos no terminal:
```bash
bundle install

rails db:seed
```
Para acessa como administrador da aplicação use o seguinte e-mail e senha:

E-mail: maria@sistemadefrete.com.br
Senha: senha123

Para acessa como usuário regular da aplicação use o seguinte e-mail e senha:

E-mail: joao@sistemadefrete.com.br
Senha: senha123
