using SistemaGestionNomina.Models;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Web.Mvc;

namespace SistemaGestionNomina.Controllers
{
    public class AutenticacionController : Controller
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString;

        // GET: Autenticacion/Login
        [HttpGet]
        public ActionResult Login()
        {
            return View();
        }

        // POST: Autenticacion/Login
        [HttpPost]
        public ActionResult Login(Usuario user)
        {
            try
            {
                DataTable dt = new DataTable();
                string mensaje = string.Empty;

                using (SqlConnection cn = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("sp_userAuthentication", cn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetros de entrada
                    cmd.Parameters.AddWithValue("@usuario", user.usuario);
                    cmd.Parameters.AddWithValue("@clave", user.clave);

                    // Parámetro de salida
                    SqlParameter outputParam = new SqlParameter("@message", SqlDbType.NVarChar, 100);
                    outputParam.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(outputParam);

                    // Ejecutar SP y llenar DataTable
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    // Leer parámetro de salida
                    cn.Open();
                    cmd.ExecuteNonQuery();
                    mensaje = outputParam.Value?.ToString();
                    cn.Close();
                }

                if (mensaje == "Autenticacion exitosa" && dt.Rows.Count > 0)
                {
                    Session["usuario"] = dt.Rows[0]["usuario"].ToString();
                    Session["rol"] = dt.Rows[0]["rol"].ToString();

                    return RedirectToAction("Index", "Home");
                }
                else
                {
                    ViewBag.Error = mensaje ?? "Usuario o contraseña incorrectos.";
                    return View();
                }
            }
            catch (Exception ex)
            {
                ViewBag.Error = "Error al iniciar sesión: " + ex.Message;
                return View();
            }
        }

        // GET: Autenticacion/Register
        public ActionResult Register()
        {
            return View();
        }

        // POST: Autenticacion/Register
        [HttpPost]
        public ActionResult Register(string usuario, string clave, string rol = "user")
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string sql = "INSERT INTO users (usuario, clave, rol) VALUES (@usuario, @clave, @rol)";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@usuario", usuario);
                    cmd.Parameters.AddWithValue("@clave", clave);
                    cmd.Parameters.AddWithValue("@rol", rol);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            return RedirectToAction("Login");
        }

        // GET: Autenticacion/AdminPanel
        public ActionResult AdminPanel()
        {
            if (Session["rol"] == null || Session["rol"].ToString() != "Admin")
            {
                return RedirectToAction("Login", "Autenticacion");
            }

            return View();
        }

        public ActionResult Logout()
        {
            // Limpiar todas las variables de sesión
            Session.Clear();
            Session.Abandon();  // Opcional, asegura que se destruya la sesión actual

            // Redirigir al login
            return RedirectToAction("Login", "Autenticacion");
        }

    }
}
