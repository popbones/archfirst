package org.archfirst.bfoms.webservice.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.archfirst.bfoms.domain.security.PasswordHashGenerator;

import com.sun.xml.wss.impl.callback.PasswordValidationCallback;
import com.sun.xml.wss.impl.callback.PasswordValidationCallback.PasswordValidationException;
import com.sun.xml.wss.impl.callback.PasswordValidationCallback.Request;

public class PasswordValidator implements PasswordValidationCallback.PasswordValidator
{
    private static String CONNECTION_POOL_JNDI_NAME =
        "bfoms_javaee_connection_pool";
    
    private static String READ_PASSWORD =
        "select passwordHash from Users where username = ?";
    
    private static String DB_ERROR = "Error accessing database";

    @Override
    public boolean validate(Request request) throws PasswordValidationException {

        // Get the username and password supplied by the user
        PasswordValidationCallback.PlainTextPasswordRequest passwordRequest
            = (PasswordValidationCallback.PlainTextPasswordRequest)request;
        String username = passwordRequest.getUsername();
        String password = passwordRequest.getPassword();
        String passwordHash =
            PasswordHashGenerator.generateSaltedHash(password, username);

        // Get the password hash stored in the database
        String passwordHashDb = null;
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        try {
            Context context = new InitialContext();
            DataSource datasource =
                (DataSource)context.lookup(CONNECTION_POOL_JNDI_NAME);
            connection = datasource.getConnection();
            statement = connection.prepareStatement(READ_PASSWORD);
            statement.setString(1, username);
            resultSet = statement.executeQuery();
            // ResultSet should have 0 or 1 record
            while(resultSet.next()) {
                passwordHashDb = resultSet.getString("passwordHash");
            }
        }
        catch (NamingException e) {
            throw new PasswordValidationException(DB_ERROR);
        }
        catch (SQLException e) {
            throw new PasswordValidationException(DB_ERROR);
        }
        finally {
            if (resultSet != null) try { resultSet.close(); } catch (SQLException e) {}
            if (statement != null) try { statement.close(); } catch (SQLException e) {}
            if (connection != null) try { connection.close(); } catch (SQLException e) {}
        }
        
        return passwordHash.equals(passwordHashDb);
    }
}