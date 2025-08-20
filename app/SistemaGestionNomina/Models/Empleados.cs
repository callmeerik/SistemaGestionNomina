using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace SistemaGestionNomina.Models
{
    public class Empleados
    {
        [Required]
        [StringLength(10)]
        public string ci { get; set; }

        [Required]
        [DataType(DataType.Date)]
        public string birth_date { get; set; }  // Podrías usar DateTime si quieres más control

        [Required]
        [StringLength(50)]
        public string first_name { get; set; }

        [Required]
        [StringLength(50)]
        public string last_name { get; set; }

        [Required]
        [EmailAddress]
        public string correo { get; set; }

        [Required]
        [RegularExpression("M|F")]
        public string gender { get; set; }

        [Required]
        [StringLength(12)]
        [DataType(DataType.Password)]
        public string clave { get; set; }
    }
}