import java.sql.*;
import java.io.*;
import java.util.*;
import java.sql.Date;


public class JDBCPostgreSQLConnection {

    private final String url ="jdbc:postgresql://localhost:5432/railway";
    private final String user ="postgres";
    private final String password ="12345";


    public Connection connect()
    {
        Connection cnct =null;

        try
        {
            cnct = DriverManager.getConnection(url,user,password);

            if(cnct !=null)
            {
                System.out.println("Connected to the PostgreSQL server successfully.");
            }
            else
            {
                System.out.println("Failed to make the connection!");
            }
        } 
        catch (SQLException e)
        {
            System.out.println(e.getMessage());
        }
        return cnct;
    }
    public static String create_name(int train_no,String doj,String choice)
    {
        String res=choice+String.valueOf(train_no);
        String temp=doj.substring(0,4)+doj.substring(5,7)+doj.substring(8);
        return res+temp;
    }

    
    public static void main(String[] args) throws Exception {
        JDBCPostgreSQLConnection app = new JDBCPostgreSQLConnection();
        Connection connection= null;
        // try{
             connection = app.connect();
            // Statement stmnt = connection.createStatement();
            // ScriptRunner sr = new ScriptRunner(connection);
            String query ="";

            try{
                // Reader reader = new BufferedReader(new FileReader("./src/railway_q.sql"));
                // sr.runScript(reader);
                File file = new File("./src/railway_q.sql");
                Scanner scan =new Scanner(file);
                while(scan.hasNextLine())
                {
                    query=query.concat(scan.nextLine()+" ");
                }
            }
            catch(IOException e){
                System.out.println(e.getLocalizedMessage());

            }
        // } catch(SQLException exception) {

        // }
        Statement stmt = connection.createStatement();
        stmt.execute(query);
        stmt.close();
        String s=JDBCPostgreSQLConnection.create_name(122345,"2022-10-22","AC");
        String s2=JDBCPostgreSQLConnection.create_name(122345,"2022-10-22","SL");
        // System.out.println(s);
        // PreparedStatement pstmt = connection.prepareStatement("Call create_table(?)");
        // pstmt.setString(1, s);
        // pstmt.execute();
        // PreparedStatement pstmt2 = connection.prepareStatement("Call create_table(?)");
        // pstmt2.setString(1, s2);
        // pstmt2.execute();

        PreparedStatement pstmt3 = connection.prepareStatement("Call fill_table(?,?,?,?,?,?)");
        pstmt3.setString(1, s);
        pstmt3.setString(2, s2);
        pstmt3.setInt(3, 12345);
        pstmt3.setDate(4, Date.valueOf("2022-10-27"));
        pstmt3.setInt(5, 2);
        pstmt3.setInt(6, 3);
        pstmt3.execute();



        connection.close();
        // System.out.println(s);
    }
}
