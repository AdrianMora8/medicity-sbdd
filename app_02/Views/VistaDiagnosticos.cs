    namespace app_02.Views
    {
    public class VistaDiagnosticos
    {
        public int ID { get; set; }
        public int ID_CITA { get; set; }               // Para POST /api/medicity/distribuida/sp_diagnostico
        public string DIAGNOSTICO { get; set; }
        public string DESCRIPCION { get; set; }
        public string TRATAMIENTO { get; set; }
        public int ID_PACIENTE { get; set; }
        public string PACIENTE { get; set; }
        public DateTime FECHAHORA { get; set; }
    }
}
