package helper;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;

public final class MysqlService {
    private boolean driverIsLoaded;
    private Connection connection;
    private final String connectionString;
    private final String dbUser;
    private final String dbPass;

    public MysqlService(String hostname, String dbName, String dbUser, String dbPass) {
        this(String.format("jdbc:mysql://%s/%s", hostname, dbName), dbUser, dbPass);
    }

    public MysqlService(String connectionString, String dbUser, String dbPass) {
        driverIsLoaded = loadDatabaseDriver();

        this.connectionString = connectionString;
        this.dbUser = dbUser;
        this.dbPass = dbPass;

        openConnection();
    }

    private boolean loadDatabaseDriver() {
        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            return true;
        } catch (ClassNotFoundException | InstantiationException | IllegalAccessException ex) { }
        return false;
    }

    public boolean isConnected() {
        return driverIsLoaded && connection != null;
    }

    public void openConnection() {
        if (driverIsLoaded && connection == null) {
            try {
                connection = DriverManager.getConnection(connectionString, dbUser, dbPass);
            } catch (SQLException ex) { }
        }
    }

    public void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException ex) {
            } finally {
                connection = null;
            }
        }
    }

    public List<Map<String, String>> executeQuery(String queryString, ArrayList<String> parameters) {
        List<Map<String, String>> result = new ArrayList<>();

        if (isConnected()) {
            try (
                PreparedStatement stmt = prepareStatement(queryString, parameters);
                ResultSet rs = stmt.executeQuery();
            ) {
                ResultSetMetaData metadata = rs.getMetaData();
                int numOfCol = metadata.getColumnCount();

                while (rs.next()) {
                    Map<String, String> row = new LinkedHashMap<>();
                    for (int i = 1; i <= numOfCol; ++i) {
                        String colName = metadata.getColumnName(i);
                        String colValue = rs.getString(i);
                        row.put(colName, colValue);
                    }
                    result.add(row);
                }
            } catch (SQLException ex) { }
        }

        return result;
    }

    public int executeUpdate(String queryString, ArrayList<String> parameters) {
        int rowsAffected = -1;

        if (isConnected()) {
            try (PreparedStatement stmt = prepareStatement(queryString, parameters)) {
                rowsAffected = stmt.executeUpdate();
            } catch (SQLException ex) { }
        }

        return rowsAffected;
    }

    private PreparedStatement prepareStatement(String queryString, ArrayList<String> parameters) throws SQLException {
        PreparedStatement stmt = connection.prepareStatement(queryString);
        for (int i = 0; i < parameters.size(); i++) {
            stmt.setString(i + 1, parameters.get(i));
        }
        return stmt;
    }
}