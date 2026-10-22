package com.quizsystem.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            System.out.println("Driver not loaded");
            e.printStackTrace();
        }
    }

    public static Connection getConnection() {

        Connection con = null;

        try {
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/online_assessment?useSSL=false&serverTimezone=UTC",
                "root",
                "28101"
            );
        } catch (Exception e) {
            System.out.println("Connection failed");
            e.printStackTrace();
        }

        return con;
    }
}