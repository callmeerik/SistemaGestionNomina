using SistemaGestionNomina.Models;
using SistemaGestionNomina.Filters;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web.Mvc;

namespace SistemaGestionNomina.Controllers
{
    public class AutenticacionController : Controller
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString;

        [HttpGet]
        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Login(Usuario user)
        {
            try
            {
                DataTable dt = new DataTable();
                string mensaje = string.Empty;

                string hashedPassword = HashPassword(user.clave);

                using (SqlConnection cn = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("sp_userAuthentication", cn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@usuario", user.usuario);
                    cmd.Parameters.AddWithValue("@clave", hashedPassword);

                    SqlParameter outputParam = new SqlParameter("@message", SqlDbType.NVarChar, 100)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outputParam);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    cn.Open();
                    cmd.ExecuteNonQuery();
                    mensaje = outputParam.Value?.ToString();
                    cn.Close();
                }

                if (mensaje == "Autenticacion exitosa" && dt.Rows.Count > 0)
                {
                    // Guardamos en sesión de forma consistente
                    Session["UserName"] = dt.Rows[0]["usuario"].ToString();
                    Session["UserRole"] = dt.Rows[0]["rol"].ToString();

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

        [HttpGet]
        public ActionResult Register()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Register(Empleados emp)
        {
            if (!ModelState.IsValid) return View(emp);

            string hashedPassword = HashPassword(emp.clave);
            string mensaje;

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("sp_insertEmployee", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ci", emp.ci);
                cmd.Parameters.AddWithValue("@birth_date", emp.birth_date);
                cmd.Parameters.AddWithValue("@first_name", emp.first_name);
                cmd.Parameters.AddWithValue("@last_name", emp.last_name);
                cmd.Parameters.AddWithValue("@correo", emp.correo);
                cmd.Parameters.AddWithValue("@gender", emp.gender);
                cmd.Parameters.AddWithValue("@clave", hashedPassword);

                SqlParameter outputParam = new SqlParameter("@mensaje", SqlDbType.NVarChar, 200)
                {
                    Direction = ParameterDirection.Output
                };
                cmd.Parameters.Add(outputParam);

                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();

                mensaje = outputParam.Value?.ToString();
            }

            ViewBag.Mensaje = mensaje;
            if (mensaje == "Empleado y usuario registrados correctamente.") return RedirectToAction("Login");
            return View(emp);
        }

        public ActionResult AdminPanel()
        {
            if (Session["UserRole"] == null || Session["UserRole"].ToString() != "Admin")
                return RedirectToAction("Login", "Autenticacion");

            return View();
        }

        public ActionResult Logout()
        {
            Session.Clear();
            Session.Abandon();
            return RedirectToAction("Login", "Autenticacion");
        }

        public string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();
                foreach (var b in bytes) builder.Append(b.ToString("x2"));
                return builder.ToString();
            }
        }
    }
}
