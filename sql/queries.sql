-- =========================================================
-- CineStream - Consultas SQL associadas ao projeto (15 consultas)
-- =========================================================

-- 1. Assinantes ativos
SELECT id_assinante, nome_completo, email
FROM Assinante
WHERE conta_ativa = TRUE;

-- 2. Planos dos assinantes
SELECT Assinante.nome_completo,
       Plano.nome_comercial,
       HistoricoAssinatura.data_inicio,
       HistoricoAssinatura.valor_cobrado
FROM HistoricoAssinatura
JOIN Assinante ON Assinante.id_assinante = HistoricoAssinatura.id_assinante
JOIN Plano ON Plano.id_plano = HistoricoAssinatura.id_plano;

-- 3. Faturas pendentes
SELECT Assinante.nome_completo,
       Fatura.valor_total,
       Fatura.data_vencimento
FROM Fatura
JOIN Assinante ON Assinante.id_assinante = Fatura.id_assinante
WHERE Fatura.data_pagamento IS NULL;

-- 4. Dispositivos dos assinantes
SELECT Assinante.nome_completo,
       Dispositivo.sistema_operacional,
       Dispositivo.endereco_mac
FROM Dispositivo
JOIN Assinante ON Assinante.id_assinante = Dispositivo.id_assinante;

-- 5. Obras infantis
SELECT titulo, idade_minima_recomendada
FROM Obra
WHERE idade_minima_recomendada <= 10;

-- 6. Obra que o usuário não concluiu e a porcentagem assistida
SELECT Assinante.nome_completo,
       Obra.titulo,
       Visualizacao.porcentagem_assistida
FROM Visualizacao
JOIN Assinante ON Assinante.id_assinante = Visualizacao.id_assinante
JOIN Obra ON Obra.id_obra = Visualizacao.id_obra
WHERE Visualizacao.porcentagem_assistida < 100;

-- 7. Usuários com conta inativa
SELECT nome_completo, email
FROM Assinante
WHERE conta_ativa = FALSE;

-- 8. Episódios por obra
SELECT Obra.titulo,
       COUNT(Episodio.numero_capitulo)
FROM Episodio
JOIN Obra ON Obra.id_obra = Episodio.id_obra
GROUP BY Obra.titulo;

-- 9. Obras vistas pelo público infantil
SELECT Perfil.nome_exibicao,
       Obra.titulo
FROM Visualizacao
JOIN Perfil
    ON Perfil.id_assinante = Visualizacao.id_assinante
   AND Perfil.numero_sequencial = Visualizacao.numero_sequencial
JOIN Obra ON Obra.id_obra = Visualizacao.id_obra
WHERE Perfil.id_classificacao = 1;

-- 10. Obras sem visualização
SELECT Obra.titulo
FROM Obra
LEFT JOIN Visualizacao ON Visualizacao.id_obra = Obra.id_obra
WHERE Visualizacao.id_visualizacao IS NULL;

-- 11. Obras finalizadas pelos usuários
SELECT Assinante.nome_completo,
       Obra.titulo,
       Visualizacao.data_hora
FROM Visualizacao
JOIN Assinante ON Assinante.id_assinante = Visualizacao.id_assinante
JOIN Obra ON Obra.id_obra = Visualizacao.id_obra
WHERE Visualizacao.porcentagem_assistida = 100;

-- 12. Total de obras cadastradas por gênero
SELECT Genero.nome,
       COUNT(ObraGenero.id_obra) AS total_obras
FROM Genero
JOIN ObraGenero ON ObraGenero.id_genero = Genero.id_genero
GROUP BY Genero.nome
ORDER BY total_obras DESC;

-- 13. Assinantes com mais de um perfil
SELECT Assinante.nome_completo,
       COUNT(Perfil.numero_sequencial) AS total_perfis
FROM Assinante
JOIN Perfil ON Perfil.id_assinante = Assinante.id_assinante
GROUP BY Assinante.nome_completo
HAVING COUNT(Perfil.numero_sequencial) > 1;

-- 14. Obras com classificação livre
SELECT titulo, ano_lancamento, idade_minima_recomendada
FROM Obra
WHERE idade_minima_recomendada = 0;

-- 15. Assinantes que nunca assistiram nada
SELECT Assinante.nome_completo,
       Assinante.email
FROM Assinante
LEFT JOIN Visualizacao ON Visualizacao.id_assinante = Assinante.id_assinante
WHERE Visualizacao.id_visualizacao IS NULL;
