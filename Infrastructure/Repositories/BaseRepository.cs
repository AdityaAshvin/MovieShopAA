using ApplicationCore.Contracts.Repositories;
using Infrastructure.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Infrastructure.Repositories
{
    public class BaseRepository<T> : IRepository<T> where T : class
    {
        protected readonly MovieShopDbContext _movieShopDbContext;
        public BaseRepository(MovieShopDbContext movieShopDbContext)
        {
            _movieShopDbContext = movieShopDbContext;
        }

        public T DeleteByID(int id)
        {
            var entity = _movieShopDbContext.Set<T>().Find(id);
            if(entity != null)
            {
                _movieShopDbContext.Set<T>().Remove(entity);
                _movieShopDbContext.SaveChanges();
                return entity;
            }
            return null;
        }

        public IEnumerable<T> GetAll()
        {
            return _movieShopDbContext.Set<T>().ToList();
        }

        public T GetById(int id)
        {
            var movieId = _movieShopDbContext.Set<T>().Find(id);
            if(movieId == null)
            {
                return null;
            }
            return movieId;
        }

        public T Insert(T entity)
        {
            _movieShopDbContext.Set<T>().Add(entity);
            _movieShopDbContext.SaveChanges();
            return entity;
        }

        public T Update(T entity)
        {
            _movieShopDbContext.Entry(entity).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
            _movieShopDbContext.SaveChanges();
            return entity;
        }
    }
}
