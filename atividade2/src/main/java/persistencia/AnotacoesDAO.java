package persistencia;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.sql.Timestamp;

import negocio.Anotacoes;

public class AnotacoesDAO {
  public ArrayList<Anotacoes> obterlista(int usuario_id, boolean lixeira) throws SQLException {
    ArrayList<Anotacoes> anotacoes = new ArrayList<Anotacoes>();
    String sql = "SELECT * FROM anotacoes WHERE usuario_id = ? AND lixeira = ? ORDER BY atualizado_em;";
    Connection connection = new ConexaoPostgreSQL().getConexao();

    try (PreparedStatement instrucaoSQL = connection.prepareStatement(sql)) {
      instrucaoSQL.setInt(1, usuario_id);
      instrucaoSQL.setBoolean(2, lixeira);
      ResultSet rs = instrucaoSQL.executeQuery();
      while (rs.next()) {
        Anotacoes anotacao = new Anotacoes();
        anotacao.setId(rs.getInt("id"));
        anotacao.setTitulo(rs.getString("titulo"));
        anotacao.setTexto(rs.getString("texto"));
        anotacao.setCor(rs.getString("cor"));
        anotacao.setAtualizado_em(rs.getTimestamp("atualizado_em"));
        anotacao.setNome_usuario(new UsuarioDAO().obter(rs.getInt("usuario_id")).getNome());
        anotacao.setUsuario_id(rs.getInt("usuario_id"));
        anotacoes.add(anotacao);
      }
    } catch (SQLException e) {
      e.printStackTrace();
    } finally {
      connection.close();
    }
    return anotacoes;
  }

  public Anotacoes obter(int id) throws SQLException {
    Anotacoes anotacao = new Anotacoes();
    String sql = "SELECT * FROM anotacoes WHERE id = ?;";
    Connection connection = new ConexaoPostgreSQL().getConexao();

    try (PreparedStatement instrucaoSQL = connection.prepareStatement(sql)) {
      instrucaoSQL.setInt(1, id);
      ResultSet rs = instrucaoSQL.executeQuery();
      while (rs.next()) {
        anotacao.setId(rs.getInt("id"));
        anotacao.setTitulo(rs.getString("titulo"));
        anotacao.setTexto(rs.getString("texto"));
        anotacao.setCor(rs.getString("cor"));
        anotacao.setAtualizado_em(rs.getTimestamp("atualizado_em"));
        anotacao.setNome_usuario(new UsuarioDAO().obter(rs.getInt("usuario_id")).getNome());
        anotacao.setUsuario_id(rs.getInt("usuario_id"));
      }
    } catch (SQLException e) {
      e.printStackTrace();
    } finally {
      connection.close();
    }
    return anotacao;
  }

  public Anotacoes adicionar(Anotacoes anotacao) throws SQLException {
    String sql = "INSERT INTO anotacoes (titulo, texto, cor, nome_usuario, usuario_id) VALUES (?, ?, ?, ?, ?) RETURNING id;";
    Connection connection = new ConexaoPostgreSQL().getConexao();

    try (PreparedStatement instrucaoSQL = connection.prepareStatement(sql)) {
      instrucaoSQL.setString(1, anotacao.getTitulo());
      instrucaoSQL.setString(2, anotacao.getTexto());
      instrucaoSQL.setString(3, anotacao.getCor());
      instrucaoSQL.setString(4, anotacao.getNome_usuario());
      instrucaoSQL.setInt(5, anotacao.getUsuario_id());

      ResultSet rs = instrucaoSQL.executeQuery();
      if (rs.next()) {
        anotacao.setId(rs.getInt("id"));
      }
    } catch (SQLException e) {
      e.printStackTrace();
    } finally {
      connection.close();
    }
    return anotacao;
  }

  public boolean editar(Anotacoes anotacao) throws SQLException {
    String sql = "UPDATE anotacoes SET titulo = ?, texto = ?, cor = ?, atualizado_em = ?, lixeira = ? WHERE id = ?;";
    Connection connection = new ConexaoPostgreSQL().getConexao();

    try (PreparedStatement instrucaoSQL = connection.prepareStatement(sql)) {
      instrucaoSQL.setString(1, anotacao.getTitulo());
      instrucaoSQL.setString(2, anotacao.getTexto());
      instrucaoSQL.setString(3, anotacao.getCor());
      instrucaoSQL.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
      instrucaoSQL.setBoolean(5, anotacao.isLixeira());
      instrucaoSQL.setInt(6, anotacao.getId());
      int resultado = instrucaoSQL.executeUpdate();
      return resultado == 1;
    } finally {
      if (connection != null) {
        connection.close();
      }
    }
  }

  public boolean deletar(int id) throws SQLException {
    String sql = "DELETE FROM anotacoes WHERE id = ?;";
    Connection connection = new ConexaoPostgreSQL().getConexao();

    try (PreparedStatement instrucaoSQL = connection.prepareStatement(sql)) {
      instrucaoSQL.setInt(1, id);
      int resultado = instrucaoSQL.executeUpdate();
      instrucaoSQL.close();
      return resultado == 1;
    } finally {
      if (connection != null) {
        connection.close();
      }
    }
  }
}
