using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ApplicationCore.Entities;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System.Security.Cryptography.X509Certificates;

namespace Infrastructure.Data
{
    public class MovieShopDbContext : DbContext
    {
        public MovieShopDbContext(DbContextOptions<MovieShopDbContext> options) : base(options)
        {

        }

        public DbSet<Genre> Genres { get; set; } //setting table name to be Genres

        public DbSet<Movie> Movies { get; set; }

        public DbSet<Trailer> Trailer { get; set; }

        public DbSet<MovieGenre> MovieGenres { get; set; }
        public DbSet<Cast> Cast { get; set; }

        public DbSet<MovieCast> MovieCasts { get; set; }

        public DbSet<User> Users { get; set; }

        public DbSet<Review> Reviews { get; set; }
        public DbSet<Favourite> Favourites { get; set; }
        public DbSet<Purchase> Purchases { get; set; }
        public DbSet<Role> Roles { get; set; }
        public DbSet<UserRole> UserRoles { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            /* WAY 1
            modelBuilder.Entity<Movie>(entity =>
            {
                entity.Property(e => e.Title).HasColumnType("varchar(20");
                entity.HasKey(e => e.Id);
            }); */

            modelBuilder.Entity<Movie>(ConfigureMovie);

            //for something else,
            //modelBuilder.Entity<EntityName>(FnName);

            modelBuilder.Entity<MovieGenre>(ConfigureMovieGenre);

            modelBuilder.Entity<MovieCast>(ConfigureMovieCast);
            modelBuilder.Entity<Review>(ConfigureReview);
            modelBuilder.Entity<Favourite>(ConfigureFavourite);
            modelBuilder.Entity<Purchase>(ConfigurePurchase);
            modelBuilder.Entity<UserRole>(ConfigureUserRole);
        }

        public void ConfigureMovie(EntityTypeBuilder<Movie> builder)
        {
            builder.ToTable("Movies"); //table name change
            builder.HasKey(m => m.Id); //PK
            builder.Property(m => m.Title).HasColumnType("varchar(20)");
            builder.Property(m => m.Overview).HasColumnType("varchar(512)");
            builder.Property(m => m.PosterUrl).HasColumnType("varchar(500)");
        }

        public void ConfigureMovieGenre(EntityTypeBuilder<MovieGenre> modelBuilder)
        {
            modelBuilder.HasKey(x => new { x.MovieId, x.GenreId });
            modelBuilder.HasOne(x => x.Movie).WithMany(x => x.MovieGenres).HasForeignKey(x => x.MovieId);
            modelBuilder.HasOne(x => x.Genre).WithMany(x => x.MovieGenres).HasForeignKey(x => x.GenreId);
        }
        public void ConfigureMovieCast(EntityTypeBuilder<MovieCast> modelBuilder)
        {
            modelBuilder.HasKey(x => new { x.MovieId, x.CastId, x.Character});
            modelBuilder.HasOne(x => x.Movie).WithMany(x => x.MovieCasts).HasForeignKey(x => x.MovieId);
            modelBuilder.HasOne(x => x.Cast).WithMany(x => x.MovieCasts).HasForeignKey(x => x.CastId);
        }
        public void ConfigureReview(EntityTypeBuilder<Review> modelBuilder)
        {
            modelBuilder.HasKey(x => new { x.MovieId, x.UserId});
            modelBuilder.HasOne(x => x.Movie).WithMany(x => x.Reviews).HasForeignKey(x => x.MovieId);
            modelBuilder.HasOne(x => x.User).WithMany(x => x.Reviews).HasForeignKey(x => x.UserId);
        }
        public void ConfigureFavourite(EntityTypeBuilder<Favourite> modelBuilder)
        {
            modelBuilder.HasKey(x => new { x.MovieId, x.UserId });
            modelBuilder.HasOne(x => x.Movie).WithMany(x => x.Favourites).HasForeignKey(x => x.MovieId);
            modelBuilder.HasOne(x => x.User).WithMany(x => x.Favourites).HasForeignKey(x => x.UserId);
        }

        public void ConfigurePurchase(EntityTypeBuilder<Purchase> modelBuilder)
        {
            modelBuilder.HasKey(x => new {x.MovieId, x.UserId});
            modelBuilder.HasOne(x => x.Movie).WithMany(x => x.Purchases).HasForeignKey(x => x.MovieId);
            modelBuilder.HasOne(x => x.User).WithMany(x => x.Purchases).HasForeignKey(x => x.UserId);
        }
        public void ConfigureUserRole(EntityTypeBuilder<UserRole> modelBuilder)
        {
            modelBuilder.HasKey(x => new { x.RoleId, x.UserId });
            modelBuilder.HasOne(x => x.User).WithMany(x => x.UserRoles).HasForeignKey(x => x.UserId);
            modelBuilder.HasOne(x => x.Role).WithMany(x => x.UserRoles).HasForeignKey(x => x.RoleId);
        }
    }
}
