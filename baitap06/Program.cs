// using System;
// using Microsoft.Data.SqlClient;
// class Program
// {
//     static void Main(string[] args)
//     {
//         string connectionString = "Server=localhost;Database=AdventureWorks2025;Trusted_Connection=True;TrustServerCertificate=True;";
//         string query = @"SELECT DepartmentID, Name FROM HumanResources.Department";
//         using (SqlConnection connection = new SqlConnection(connectionString))
//         {
//             try
//             {
//                 connection.Open();
//                 Console.WriteLine("Kết nối CSDL thành công!");
//                 Console.WriteLine("--------------------------------");
//                 using (SqlCommand command = new SqlCommand(query, connection))
//                 {
//                     using (SqlDataReader reader = command.ExecuteReader())
//                     {
//                         Console.WriteLine("{0,-15} {1}", "DepartmentID", "Name");
//                         Console.WriteLine("--------------------------------");
//                         while (reader.Read())
//                         {
//                             int departmentID = reader.GetInt16(0);
//                             string name = reader.GetString(1);
//                             Console.WriteLine("{0,-15} {1}", departmentID, name);
//                         }
//                     }
//                 }
//             }
//             catch (Exception ex)
//             {
//                 Console.WriteLine("Có lỗi xảy ra:");
//                 Console.WriteLine(ex.Message);
//             }
//         }
//         Console.WriteLine("\nNhấn phím bất kỳ để kết thúc...");
//         Console.ReadKey();
//     }
// }

// static void Main()
//     {
//         string connectionString = "Server=localhost;Database=AdventureWorks2025;Trusted_Connection=True;TrustServerCertificate=True;";
//         Console.Write("Nhập họ cần tìm: ");
//         string lastName = Console.ReadLine();
//         string sql = @"Select BusinessEntityID, FirstName, LastName from Person.Person where LastName = @LastName";
//         try
//         {
//             using (SqlConnection connection = new SqlConnection(connectionString))
//             using (SqlCommand command = new SqlCommand(sql, connection))
//             {
//                 command.Parameters.AddWithValue("@LastName", lastName);
//                 connection.Open();
//                 using (SqlDataReader reader = command.ExecuteReader())
//                 {
//                     Console.WriteLine("\n===== KẾT QUẢ TÌM KIẾM =====");
//                     bool coDuLieu = false;
//                     while (reader.Read())
//                     {
//                         coDuLieu = true;
//                         Console.WriteLine($"ID: {reader["BusinessEntityID"]} | " + $"Họ: {reader["LastName"]} | " + $"Tên: {reader["FirstName"]}");
//                     }
//                     if (!coDuLieu)
//                     {
//                         Console.WriteLine("Không tìm thấy người nào có họ này.");
//                     }
//                 }
//             }
//         }
//         catch(Exception ex)
//         {
//             Console.WriteLine("Có lỗi xảy ra: " + ex.Message);
//         }
//         Console.WriteLine("\n Nhấn phím bất kỳ để kết thúc...");
//         Console.ReadKey();
//     }


//    static void Main()
//     {
//         string connectionString = "Server=localhost;Database=AdventureWorks2025;Trusted_Connection=True;TrustServerCertificate=True;";
//         Console.Write("Nhập mã nhân viên(BusinessEntityID): ");
//         int businessEntityID = int.Parse(Console.ReadLine());
//         Console.Write("Nhập chức danh mới (JobTitle): ");
//         string jobTitle = Console.ReadLine();
//         string sql =@" update HumanResources.Employee set JobTitle = @JobTitle where BusinessEntityID = @BusinessEntityID";
//         try
//         {
//             using (SqlConnection connection = new SqlConnection(connectionString))
//             using (SqlCommand command = new SqlCommand(sql, connection))
//             {
//                 command.Parameters.AddWithValue("@JobTitle", jobTitle);
//                 command.Parameters.AddWithValue("@BusinessEntityID", businessEntityID);
//                 connection.Open();
//                 int soDong = command.ExecuteNonQuery();
//                 if (soDong > 0)
//                 {
//                     Console.WriteLine("Cập nhật thành công!");
//                 }
//                 else
//                 {
//                     Console.WriteLine("Không tìm thấy nhân viên");
//                 }
//             }
//         }
//         catch (Exception ex)
//         {
//             Console.WriteLine("Có lỗi xảy ra: " + ex.Message);
//         }
//         Console.WriteLine("\n Nhấn phím bất kỳ để kết thúc...");
//         Console.ReadKey();
//     }


//     static void Main()
//     {
//         Console.Write("Nhập mã sản phẩm (ProductID): ");
//         int productID = int.Parse(Console.ReadLine());
//         XoaSanPham(productID);
//         Console.WriteLine("\nNhấn phím bất kỳ để kết thúc...");
//         Console.ReadKey();
//     }
//     static void XoaSanPham(int productID)
//     {
//         string connectionString = "Server=localhost;Database=AdventureWorks2025;Trusted_Connection=True;TrustServerCertificate=True;";
//         string sql = @"DELETE from Production.Product where ProductID = @ProductID";
//         try
//         {
//             using (SqlConnection connection = new SqlConnection(connectionString))
//             {
//                 using (SqlCommand command = new SqlCommand(sql, connection))
//                 {
//                     command.Parameters.AddWithValue("@ProductID", productID);
//                     connection.Open();
//                     int soDong = command.ExecuteNonQuery();
//                     if (soDong > 0)
//                     {
//                         Console.WriteLine("Xóa sản phẩm thành công!");
//                     }
//                     else
//                     {
//                         Console.WriteLine("Không tìm thấy sản phẩm");
//                     }
//                 }
//             }
//         }
//         catch (SqlException)
//         {
//             Console.WriteLine("Không thể xóa sản phẩm này vì dữ liệu đang được sử dụng");
//         }
//     }
// }


using System;
using System.Collections.Generic;
using Microsoft.Data.SqlClient;
class Product
{
    public int ProductID { get; set; }
    public string Name { get; set; }
    public string ProductNumber { get; set; }
    public decimal ListPrice { get; set; }
}
class Program
{
    static string connectionString = "Server=localhost;Database=AdventureWorks2025;Trusted_Connection=True;TrustServerCertificate=True;";
    static List<Product> GetTop10Products()
    {
        List<Product> products = new List<Product>();
        string sql = @" SELECT TOP 10 ProductID, Name, ProductNumber, ListPrice FROM Production.Product ORDER BY ProductID";
        try
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    connection.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Product product = new Product();
                            product.ProductID = Convert.ToInt32(reader["ProductID"]);
                            product.Name = reader["Name"].ToString();
                            product.ProductNumber = reader["ProductNumber"].ToString();
                            product.ListPrice = Convert.ToDecimal(reader["ListPrice"]);
                            products.Add(product);
                        }
                    }
                }
            }
        }
        catch (SqlException ex)
        {
            Console.WriteLine("Lỗi SQL: " + ex.Message);
        }
        return products;
    }
    static void Main()
    {
        List<Product> products = GetTop10Products();
        Console.WriteLine("===== TOP 10 SẢN PHẨM =====");
        foreach (Product product in products)
        {
            Console.WriteLine($"ProductID: {product.ProductID}");
            Console.WriteLine($"Tên: {product.Name}");
            Console.WriteLine($"Mã sản phẩm: {product.ProductNumber}");
            Console.WriteLine($"Giá: {product.ListPrice:N2}");
            Console.WriteLine("-----------------------------");
        }
        Console.WriteLine("\nNhấn phím bất kỳ để kết thúc...");
        Console.ReadKey();
    }
}




