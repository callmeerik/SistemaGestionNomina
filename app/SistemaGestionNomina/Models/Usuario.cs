using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SistemaGestionNomina.Models
{
    public class Usuario
    {
        public int emp_no { get; set; }   
        public string usuario { get; set; } 
        public string clave { get; set; } 
        public string rol { get; set; } 

    }
}