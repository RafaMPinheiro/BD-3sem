package atividade;

import java.util.HashMap;
import java.util.Map;

import negocio.Anotacoes;
import persistencia.AnotacoesDAO;
import persistencia.UsuarioDAO;
import spark.ModelAndView;
import spark.template.mustache.MustacheTemplateEngine;
import static spark.Spark.*;

public class Main {
  public static void main(String[] args) {

    get("/", (req, res) -> {
      Map map = new HashMap();
      map.put("usuario", new UsuarioDAO().listar());
      return new ModelAndView(map, "index.html");
    }, new MustacheTemplateEngine());

    get("/user/:id", (req, res) -> {
      Map map = new HashMap();
      int id = Integer.parseInt(req.params(":id"));
      map.put("usuario", new UsuarioDAO().obter(id));
      map.put("anotacoes", new AnotacoesDAO().obterlista(id));
      return new ModelAndView(map, "anotacoes.html");
    }, new MustacheTemplateEngine());

    get("/novaAnotacoes/:id", (req, res) -> {
      Map map = new HashMap();
      int id = Integer.parseInt(req.params(":id"));
      map.put("usuario", id);
      return new ModelAndView(map, "formulario.html");
    }, new MustacheTemplateEngine());

    post("/adicionar", (req, res) -> {
      int user_id = Integer.parseInt(req.queryParams("usuario_id"));

      Anotacoes anotacoes = new Anotacoes();
      anotacoes.setTitulo(req.queryParams("titulo"));
      anotacoes.setTexto(req.queryParams("texto"));
      anotacoes.setCor(req.queryParams("cor"));
      anotacoes.setNome_usuario(new UsuarioDAO().obter(user_id).getNome());
      anotacoes.setUsuario_id(user_id);
      new AnotacoesDAO().adicionar(anotacoes);

      res.redirect("/user/" + user_id);
      return null;
    });

    get("/editarAnotacoes/:user/:id", (req, res) -> {
      Map map = new HashMap();
      map.put("usuario", Integer.parseInt(req.params(":user")));
      map.put("anotacao", new AnotacoesDAO().obter(Integer.parseInt(req.params(":id"))));
      return new ModelAndView(map, "editar_anotacao.html");
    }, new MustacheTemplateEngine());

    post("/editarAnotacoes", (req, res) -> {
      int user_id = Integer.parseInt(req.queryParams("usuario_id"));
      int id = Integer.parseInt(req.queryParams("id"));

      Anotacoes anotacao = new AnotacoesDAO().obter(id);
      anotacao.setTitulo(req.queryParams("titulo"));
      anotacao.setTexto(req.queryParams("texto"));
      anotacao.setCor(req.queryParams("cor"));
      new AnotacoesDAO().editar(anotacao);

      res.redirect("/user/" + user_id);
      return null;
    });

    post("/deletarAnotacoes/:user/:id", (req, res) -> {
      int user_id = Integer.parseInt(req.params(":user"));
      int id = Integer.parseInt(req.params(":id"));

      new AnotacoesDAO().deletar(id);
      res.redirect("/user/" + user_id);
      return null;
    });

  }
}
