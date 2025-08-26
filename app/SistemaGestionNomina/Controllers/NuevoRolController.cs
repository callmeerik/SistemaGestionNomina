using SistemaGestionNomina.Filters;
using SistemaGestionNomina.Models;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Mvc;

namespace SistemaGestionNomina.Controllers
{
    public class NuevoRolController : Controller
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString;

        // GET: NuevoRol
        [AuthorizeRole("Admin")]
        public ActionResult Index()
        {
            return View();
        }

        // POST: NuevoRol
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Index(CambiarRol model)
        {
            if (ModelState.IsValid)
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_cambiarRolUsuario", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        // Parámetros de entrada
                        cmd.Parameters.AddWithValue("@usuario", model.Usuario);
                        cmd.Parameters.AddWithValue("@nuevoRol", model.NuevoRol);

                        // Parámetro de salida
                        SqlParameter outputMessage = new SqlParameter("@message", SqlDbType.NVarChar, 100)
                        {
                            Direction = ParameterDirection.Output
                        };
                        cmd.Parameters.Add(outputMessage);

                        con.Open();
                        cmd.ExecuteNonQuery();

                        // Recuperamos el mensaje del SP
                        ViewBag.Mensaje = outputMessage.Value.ToString();
                    }
                }
            }

            return View(model);
        }
    }
}
