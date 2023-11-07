package persistencia;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ConexaoPostgreSQL {
    private String host;
    private String username;
    private String password;
    private String dbname;
    private String port;

    public ConexaoPostgreSQL() {
        this.host = "localhost";
        this.dbname = "atividade2";
        this.username = "postgres";
        this.password = "postgres";
        this.port = "5432";
    }

    public Connection getConexao() {
        String url = "jdbc:postgresql://" + this.host + ":" + this.port + "/" + this.dbname;
        try {
            System.out.println("Show de bola! Estou 'connect'");
            return DriverManager.getConnection(url, this.username, this.password);
        } catch (SQLException ex) {
            System.out.println("Deu xabum na conexao!");
            Logger.getLogger(ConexaoPostgreSQL.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

}
