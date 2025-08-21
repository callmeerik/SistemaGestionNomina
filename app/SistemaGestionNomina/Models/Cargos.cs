namespace SistemaGestionNomina.Models
{
    public class Cargos
    {
        public int emp_no { get; set; }
        public string ci { get; set; }
        public string NombreCompleto { get; set; }
        public string CargoActual { get; set; }
        public string Desde { get; set; }
        public string Hasta { get; set; }
    }

    public class Historial
    {
        public string Title { get; set; }
        public string Desde { get; set; }
        public string Hasta { get; set; }
        public int DuracionMeses { get; set; }
    }
}
