package helper;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class UserAuthenticator {
    // private boolean driverIsLoaded;
    // private Connection conn;
    private final String tableName;
    private final String usernameField;
    private final String passwordField;
    private MysqlService dbService;
    
    /**
     *
     * @param hostname
     * @param dbName
     * @param dbUser
     * @param dbPass
     * @param tableName
     * @param usernameField
     * @param passwordField
     */
    public UserAuthenticator(String hostname, String dbName, String dbUser, String dbPass, String tableName, String usernameField, String passwordField) {
        dbService = new MysqlService(hostname, dbName, dbUser, dbPass);
        dbService.openConnection();

        this.tableName = tableName;
        this.usernameField = usernameField;
        this.passwordField = passwordField;
    }
    
    public boolean isConnected() {
        return dbService.isConnected();
    }
    
    public void close() {
        dbService.closeConnection();
    }
    
    public Map<String, String> login(String username, String password) {
        Map<String, String> user = new LinkedHashMap<>();
        if (!isConnected()) {
            return user;
        }
        
        List<String> parameters = new ArrayList<String>(2) {{
            add(username);
            add(password);
        }};
        List<Map<String, String>> result = dbService.executeQuery(String.format("SELECT * FROM %s WHERE %s = ? AND %s = ?", tableName, usernameField, passwordField), parameters);
        
        if (result.size() == 1) {
            user = result.get(0);
        }
        
        return user;
    }
}