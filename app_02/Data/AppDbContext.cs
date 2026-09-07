using app_02.DTO;
using app_02.Views;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace app2.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(
        DbContextOptions<AppDbContext> options)
        : base(options)
        {

        }
        public DbSet<ConsultaGeneral> ConsultaGeneral { get; set; }
        public DbSet<VistaDoctores> VistaDoctores { get; set; }
        public DbSet<VistaDiagnosticos> VistaDiagnosticos { get; set; }
        public DbSet<VistaPacientes> VistaPacientes { get; set; }
        public DbSet<VistaCitas> VistaCitas { get; set; }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<ConsultaGeneral>(entity =>
            {
                entity.HasNoKey();
                entity.ToView("consulta_general");
            });

            modelBuilder.Entity<VistaDoctores>(entity =>
            {
                entity.HasNoKey();
                entity.ToView("vista_doctores");
            });

            modelBuilder.Entity<VistaDiagnosticos>(entity =>
            {
                entity.HasNoKey();
                entity.ToView("vista_diagnosticos");
            });

            modelBuilder.Entity<VistaPacientes>(entity =>
            {
                entity.HasNoKey();
                entity.ToView("vista_pacientes");
            });

            modelBuilder.Entity<VistaCitas>(entity =>
            {
                entity.HasNoKey();
                entity.ToView("vista_citas");
            });
        }
    }
}
