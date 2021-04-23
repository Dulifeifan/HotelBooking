using Autofac;
using Autofac.Integration.Mvc;
using Autofac.Integration.WebApi;
using HotelBooking.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;

namespace HotelBooking.Web {
    public class ContainerConfig {
        internal static void RegisterContainer(HttpConfiguration httpConfiguration) {
            var builder = new ContainerBuilder();
            builder.RegisterControllers(typeof(MvcApplication).Assembly);
            builder.RegisterApiControllers(typeof(MvcApplication).Assembly);
            //builder.RegisterType<InMemoryRoomData>()
                //.As<IRoomData>()
                //.SingleInstance();

            //builder.RegisterType<SqlRoomData>()
            //    .As<IRoomData>()
            //    .InstancePerRequest();
            //builder.RegisterType<HotelBookingDbContext>()
            //    .InstancePerRequest();

            builder.RegisterType<HotelBookingMVCContext>()
                .InstancePerRequest();

            var container = builder.Build();
            DependencyResolver.SetResolver(new AutofacDependencyResolver(container));
            httpConfiguration.DependencyResolver = new AutofacWebApiDependencyResolver(container);
        }
    }
}