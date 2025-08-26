using SistemaGestionNomina.Filters;
using SistemaGestionNomina.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Mvc;

namespace SistemaGestionNomina.Controllers
{
    public class DashboardController : Controller
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString;
        
        [AuthorizeRole("Admin", "RRHH")]
        public ActionResult Index()
        {
            Dashboard dashModel = new Dashboard();
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("sp_dashboardNomina", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        // obtener total de empleados
                        if ( reader.Read() )
                        {
                            dashModel.total_empleados = Convert.ToInt32(reader["total_empleados"]);
                        }

                        // obtener distribucion or genero
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                dashModel.genero.Add(reader.GetString(0), reader.GetInt32(1));
                            }
                        }

                        // obtener total de departamentos
                        if ( reader.NextResult() && reader.Read() )
                        {
                            dashModel.total_departamentos = reader.GetInt32(0);
                        }

                        // obteniendo num empleados por departamento
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                dashModel.empleados_dept.Add(reader.GetString(0), reader.GetInt32(1));
                            }
                        }

                        // promedio de slaario
                        if (reader.NextResult() && reader.Read())
                        {
                            dashModel.promedio_salario = reader.GetInt64(0);
                        }

                        // promedio de salario por dept
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                dashModel.salario_dept.Add(reader.GetString(0), reader.GetInt64(1));
                            }
                        }
                    }
                }
            }catch(SqlException ex)
            {
                TempData["Error"] = $" Error base de datos: {ex.Message}";
            }
            catch(Exception ex)
            {
                TempData["Error"] = $" Ocurrió un error: {ex.Message}";
            }
            return View(dashModel);
        }
    }
}