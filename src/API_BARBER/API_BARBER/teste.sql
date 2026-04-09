
SELECT
    a.id_usuario,
    a.nome,
    a.email,
    c.nome as nome_perfil
FROM
    tb_usuarios a
INNER JOIN tb_usuarios_perfis b ON a.id_usuario = b.id_usuario
INNER JOIN tb_perfis c ON c.id_perfil = b.id_perfil
WHERE
    a.email = 'joao.teste@gmail.com';