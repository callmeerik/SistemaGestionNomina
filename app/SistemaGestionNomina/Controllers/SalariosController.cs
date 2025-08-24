using System;
using System.Collections.Generic;
using System.Web.Mvc;
using SistemaGestionNomina.Models;
using System.Data.SqlClient;
using System.Configuration;

namespace SistemaGestionNomina.Controllers
{
    public class SalariosController : Controller
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString;

        // ✅ GET: Salarios (lista de empleados con salario actual)
        public ActionResult Index()
        {
            var empleados = new List<EmpleadoSalarioActual>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM VW_EmpleadosSalarioActual", conn);
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    empleados.Add(new EmpleadoSalarioActual
                    {
                        emp_no = Convert.ToInt32(reader["emp_no"]),
                        ci = reader["ci"].ToString(),
                        first_name = reader["first_name"].ToString(),
                        last_name = reader["last_name"].ToString(),
                        hire_date = Convert.ToDateTime(reader["hire_date"]),
                        salary = Convert.ToInt64(reader["salary"]),
                        from_date = Convert.ToDateTime(reader["from_date"]),
                        to_date = reader["to_date"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["to_date"])
                    });
                }
            }

            return View(empleados); // 👈 Vista recibe la lista
        }

        // ✅ GET: Historial de un empleado
        public ActionResult Historial(int id)
        {
            var historial = new List<HistorialSalario>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM VW_HistorialSalarios WHERE emp_no=@id", conn);
                cmd.Parameters.AddWithValue("@id", id);

                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    historial.Add(new HistorialSalario
                    {
                        emp_no = Convert.ToInt32(reader["emp_no"]),
                        first_name = reader["first_name"].ToString(),
                        last_name = reader["last_name"].ToString(),
                        salary = Convert.ToDecimal(reader["salary"]),
                        from_date = Convert.ToDateTime(reader["from_date"]),
                        to_date = reader["to_date"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["to_date"])
                    });
                }
            }

            return View(historial); // 👈 Vista recibe historial de 1 empleado
        }

        // GET: Mostrar formulario para asignar salario
        public ActionResult AsignarSalario(int emp_no)
        {
            // Traer datos del empleado para mostrar en la vista
            HistorialSalario empleado = null;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(
                    "SELECT TOP 1 e.emp_no, e.first_name, e.last_name FROM employees e WHERE e.emp_no=@id", conn);
                cmd.Parameters.AddWithValue("@id", emp_no);

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    empleado = new HistorialSalario
                    {
                        emp_no = Convert.ToInt32(reader["emp_no"]),
                        first_name = reader["first_name"].ToString(),
                        last_name = reader["last_name"].ToString()
                    };
                }
            }

            return View(empleado); // Pasa empleado a la vista
        }

        // POST: Guardar el salario
        [HttpPost]
        public ActionResult AsignarSalario(int emp_no, decimal salario)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("sp_registrarSalario", conn);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@emp_no", emp_no);
                cmd.Parameters.AddWithValue("@nuevo_salario", salario);

                cmd.ExecuteNonQuery();
            }

            return RedirectToAction("Index");
        }


    }
}

