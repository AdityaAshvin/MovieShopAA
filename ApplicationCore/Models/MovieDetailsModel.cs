using ApplicationCore.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ApplicationCore.Models
{
    public class MovieDetailsModel
    {
        public int Id { get; set; }
        public decimal? Budget { get; set; }
        public string? Overview { get; set; }
        public string? PosterUrl { get; set; }
        public decimal? Revenue { get; set; }
        public string? Tagline { get; set; }
        public string? Title { get; set; }
        public int? Runtime { get; set; }
        public string BackdropUrl { get; set; }
        public int? ReleaseYear { get; set; }
        public DateTime? ReleaseDate {  get; set; }
        public string TmdbURL { get; set; }
        public string ImdbURL {  get; set; }
        public IEnumerable<CastModel> Casts { get; set; }
        public IEnumerable<TrailerModel> Trailers { get; set; }
        public IEnumerable<GenreModel> Genres { get; set; }
        public IEnumerable<ReviewModel> Reviews { get; set; }
    }
}
