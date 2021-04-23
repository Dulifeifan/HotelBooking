using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(HotelBooking.Web.Startup))]
namespace HotelBooking.Web
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
