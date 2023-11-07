package persistencia;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import negocio.Usuario;

public class UsuarioDAO {
  public ArrayList<Usuario> listar() throws SQLException {
    ArrayList<Usuario> usuarios = new ArrayList<Usuario>();
    String sql = "SELECT * FROM usuario;";
    Connection connection = new ConexaoPostgreSQL().getConexao();

    try (PreparedStatement instrucaoSQL = connection.prepareStatement(sql)) {
      ResultSet rs = instrucaoSQL.executeQuery();
      while (rs.next()) {
        Usuario p = new Usuario();
        p.setId(rs.getInt("id"));
        p.setNome(rs.getString("nome"));
        p.setEmail(rs.getString("email"));
        p.setSenha(rs.getString("senha"));
        usuarios.add(p);
      }
    } catch (SQLException e) {
      e.printStackTrace();
    } finally {
      connection.close();
    }
    return usuarios;
  }

  public boolean deletar(int id) throws SQLException {
    String sql = "BEGIN; DELETE FROM anotacao WHERE usuario_id = ?; DELETE FROM usuario WHERE id = ?; COMMIT;";
    Connection connection = new ConexaoPostgreSQL().getConexao();

    try (PreparedStatement instrucaoSQL = connection.prepareStatement(sql)) {
      instrucaoSQL.setInt(1, id);
      instrucaoSQL.setInt(2, id);
      int resultado = instrucaoSQL.executeUpdate();
      return resultado == 1;
    } catch (SQLException e) {
      e.printStackTrace();
    } finally {
      connection.close();
    }
    return false;
  }

  public void inserir(Usuario usuario) throws SQLException {
    String sql = "INSERT INTO usuario (nome, email, senha) VALUES (?,?,?) RETURNING id;";
    Connection connection = new ConexaoPostgreSQL().getConexao();

    try (PreparedStatement instrucaoSQL = connection.prepareStatement(sql)) {
      instrucaoSQL.setString(1, usuario.getNome());
      instrucaoSQL.setString(2, usuario.getEmail());
      instrucaoSQL.setString(3, usuario.getSenha());

      ResultSet rs = instrucaoSQL.executeQuery();
      if (rs.next()) {
        usuario.setId(rs.getInt("id"));
      }
    } catch (SQLException e) {
      e.printStackTrace();
    } finally {
      connection.close();
    }
  }

  public boolean editar(Usuario usuario) throws SQLException {
    String sql = "UPDATE usuario SET nome = ?, email = ?, senha = ? WHERE id = ?;";
    Connection connection = new ConexaoPostgreSQL().getConexao();

    try (PreparedStatement instrucaoSQL = connection.prepareStatement(sql)) {
      instrucaoSQL.setString(1, usuario.getNome());
      instrucaoSQL.setString(2, usuario.getEmail());
      instrucaoSQL.setString(3, usuario.getSenha());
      instrucaoSQL.setInt(4, usuario.getId());

      int resultado = instrucaoSQL.executeUpdate();
      return resultado == 1;
    } catch (SQLException e) {
      e.printStackTrace();
    } finally {
      connection.close();
    }
    return false;
  }

  public Usuario obter(int id) throws SQLException {
    String sql = "SELECT * FROM usuario WHERE id = ?;";
    Connection connection = new ConexaoPostgreSQL().getConexao();

    try (PreparedStatement instrucaoSQL = connection.prepareStatement(sql)) {
      instrucaoSQL.setInt(1, id);
      ResultSet rs = instrucaoSQL.executeQuery();
      Usuario p = new Usuario();
      if (rs.next()) {
        p.setId(rs.getInt("id"));
        p.setNome(rs.getString("nome"));
        p.setEmail(rs.getString("email"));
        p.setSenha(rs.getString("senha"));
      }
      return p;
    } catch (SQLException e) {
      e.printStackTrace();
    } finally {
      connection.close();
    }
    return null;
  }
}
