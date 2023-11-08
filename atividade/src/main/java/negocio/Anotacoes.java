package negocio;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class Anotacoes {
  private int id;
  private String titulo;
  private String texto;
  private String cor;
  private String criado_em;
  private boolean lixeira;
  private String nome_usuario;
  private int usuario_id;

  public Anotacoes() {
  }

  public int getId() {
    return id;
  }

  public void setId(int id) {
    this.id = id;
  }

  public String getTitulo() {
    return titulo;
  }

  public void setTitulo(String titulo) {
    this.titulo = titulo;
  }

  public String getTexto() {
    return texto;
  }

  public void setTexto(String texto) {
    this.texto = texto;
  }

  public String getCor() {
    return cor;
  }

  public void setCor(String cor) {
    this.cor = cor;
  }

  public String getCriado_em() {
    return criado_em;
  }

  public void setCriado_em(Timestamp criado_em) {
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    this.criado_em = sdf.format(criado_em);
  }

  public boolean isLixeira() {
    return lixeira;
  }

  public void setLixeira(boolean lixeira) {
    this.lixeira = lixeira;
  }

  public String getNome_usuario() {
    return nome_usuario;
  }

  public void setNome_usuario(String nome_usuario) {
    this.nome_usuario = nome_usuario;
  }

  public int getUsuario_id() {
    return usuario_id;
  }

  public void setUsuario_id(int usuario_id) {
    this.usuario_id = usuario_id;
  }

}
