using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Mvc;
using SistemaGestionNomina.Models;

namespace SistemaGestionNomina.Controllers
{
    public class CargosController : Controller
    {
        // Lista de empleados con cargo actual y opción de buscar por cédula
        public ActionResult Index(string ci = null)
        {
            List<Cargos> lista = new List<Cargos>();
            ViewBag.CiBusqueda = ci;

            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString))
                {
                    SqlCommand cmd = new SqlCommand("sp_listEmployeesCurrentTitles", conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    while (dr.Read())
                    {
                        var emp = new Cargos
                        {
                            emp_no = dr["emp_no"] != DBNull.Value ? Convert.ToInt32(dr["emp_no"]) : 0,
                            ci = dr["ci"] != DBNull.Value ? dr["ci"].ToString() : "",
                            NombreCompleto = (dr["first_name"] != DBNull.Value ? dr["first_name"].ToString() : "") + " " +
                                             (dr["last_name"] != DBNull.Value ? dr["last_name"].ToString() : ""),
                            CargoActual = dr["title"] != DBNull.Value ? dr["title"].ToString() : "",
                            Desde = dr["from_date"] != DBNull.Value ? Convert.ToDateTime(dr["from_date"]).ToString("yyyy-MM-dd") : "",
                            Hasta = dr["to_date"] != DBNull.Value ? Convert.ToDateTime(dr["to_date"]).ToString("yyyy-MM-dd") : ""
                        };

                        // Filtrar por cédula si se ingresó
                        if (string.IsNullOrEmpty(ci) || emp.ci.Contains(ci))
                        {
                            lista.Add(emp);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ViewBag.Error = "Error al cargar empleados: " + ex.Message;
            }

            return View(lista);
        }

        // GET: Asignar cargo
        [HttpGet]
        public ActionResult AsignarCargo(int emp_no)
        {
            Cargos empleado = new Cargos();

            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString))
                {
                    SqlCommand cmd = new SqlCommand("sp_listEmployeesCurrentTitles", conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    while (dr.Read())
                    {
                        if (Convert.ToInt32(dr["emp_no"]) == emp_no)
                        {
                            empleado.emp_no = emp_no;
                            empleado.ci = dr["ci"].ToString();
                            empleado.NombreCompleto = dr["first_name"].ToString() + " " + dr["last_name"].ToString();
                            break;
                        }
                    }
                }
            }
            catch { }

            return View(empleado);
        }

        // POST: Asignar cargo
        [HttpPost]
        public ActionResult AsignarCargo(int emp_no, string title)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString))
                {
                    SqlCommand cmd = new SqlCommand("sp_assignTitle", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@emp_no", emp_no);
                    cmd.Parameters.AddWithValue("@title", title);

                    SqlParameter outputMsg = new SqlParameter("@message", SqlDbType.NVarChar, 200)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outputMsg);

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    TempData["Mensaje"] = outputMsg.Value.ToString();
                }

                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Error al asignar cargo: " + ex.Message;
                return RedirectToAction("Index");
            }
        }

        // Historial de cargos
        public ActionResult Historial(int emp_no)
        {
            List<Historial> historial = new List<Historial>();

            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString))
                {
                    SqlCommand cmd = new SqlCommand("sp_titlesHistory", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@emp_no", emp_no);

                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    while (dr.Read())
                    {
                        historial.Add(new Historial
                        {
                            Title = dr["title"].ToString(),
                            Desde = dr["from_date"] != DBNull.Value ? Convert.ToDateTime(dr["from_date"]).ToString("yyyy-MM-dd") : "",
                            Hasta = dr["to_date"] != DBNull.Value ? Convert.ToDateTime(dr["to_date"]).ToString("yyyy-MM-dd") : "",
                            DuracionMeses = dr["meses_duracion"] != DBNull.Value ? Convert.ToInt32(dr["meses_duracion"]) : 0
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Error al cargar historial: " + ex.Message;
            }

            return View(historial);
        }
    }
}
