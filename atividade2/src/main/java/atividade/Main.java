package atividade;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.servlet.http.Part;

import negocio.Anotacoes;
import persistencia.AnotacoesDAO;
import persistencia.UsuarioDAO;
import spark.ModelAndView;
import spark.template.mustache.MustacheTemplateEngine;
import static spark.Spark.*;

public class Main {
  public static void main(String[] args) {
    File uploadDir = new File("upload");
    uploadDir.mkdir(); // create the upload directory if it doesn't exist

    staticFiles.externalLocation("upload");

    get("/", (req, res) -> {
      Map map = new HashMap();
      map.put("usuario", new UsuarioDAO().listar());
      return new ModelAndView(map, "index.html");
    }, new MustacheTemplateEngine());

    get("/user/:id", (req, res) -> {
      Map map = new HashMap();
      int id = Integer.parseInt(req.params(":id"));
      map.put("usuario", new UsuarioDAO().obter(id));
      map.put("anotacoes", new AnotacoesDAO().obterlista(id, false));
      map.put("lixeira", new AnotacoesDAO().obterlista(id, true));
      return new ModelAndView(map, "anotacoes.html");
    }, new MustacheTemplateEngine());

    get("/adicionar/:id", (req, res) -> {
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

      Part uploadedFile = req.raw().getPart("imagem");
      if (uploadedFile != null) {
        // Define a path where you want to store the uploaded files
        String uploadDirPath = "upload/";
        Path path = Paths.get(uploadDirPath + uploadedFile.getSubmittedFileName());
        try (InputStream input = uploadedFile.getInputStream()) {
          Files.copy(input, path);
        }
        anotacoes.setFoto(path.toString()); // Set the file path to your 'anotacoes' object
      }

      new AnotacoesDAO().adicionar(anotacoes);

      res.redirect("/user/" + user_id);
      return null;
    });

    get("/editar/:user/:id", (req, res) -> {
      Map map = new HashMap();
      map.put("usuario", Integer.parseInt(req.params(":user")));
      map.put("anotacao", new AnotacoesDAO().obter(Integer.parseInt(req.params(":id"))));
      return new ModelAndView(map, "editar_anotacao.html");
    }, new MustacheTemplateEngine());

    post("/editar", (req, res) -> {
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

    post("/lixeira/:user/:id", (req, res) -> {
      int user_id = Integer.parseInt(req.params(":user"));
      int id = Integer.parseInt(req.params(":id"));
      boolean isLixo = Boolean.parseBoolean(req.queryParams("lixeira"));

      Anotacoes anotacao = new AnotacoesDAO().obter(id);
      anotacao.setLixeira(isLixo);
      new AnotacoesDAO().editar(anotacao);

      res.redirect("/user/" + user_id);
      return null;
    });

    post("/deletar/:user/:id", (req, res) -> {
      int user_id = Integer.parseInt(req.params(":user"));
      int id = Integer.parseInt(req.params(":id"));

      new AnotacoesDAO().deletar(id);
      res.redirect("/user/" + user_id);
      return null;
    });
  }
}
