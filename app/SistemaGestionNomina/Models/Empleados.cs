using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace SistemaGestionNomina.Models
{
    public class Empleados
    {
        public int emp_no { get; set; }
        public string ci { get; set; }
        public string birth_date { get; set; }
        public string first_name { get; set; }
        public string last_name { get; set; }
        public char gender { get; set; }
        public string hire_date { get; set; }
        public string correo {  get; set; }
        public bool is_active { get; set; } = true;
        public string clave { get; set; } // clave de usuario
    }
}