using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Entities
{
    public class Address
    {
        public string AddressCode1 { get; set; }
        public string AddressCode2 { get; set; }
        private City _city = new City();

        public City City
        {
            get { return _city; }
            set { _city = value; }
        }

        public string ZipCode { get; set; }
        public string LandMark { get; set; }
    }

    public class City
    {
        public long CityId { get; set; }
        public string Name { get; set; }
        State _region = new State();

        public State State
        {
            get { return _region; }
            set { _region = value; }
        }

    }

    public class State
    {
        public long RegionId { get; set; }
        private Country _country = new Country();

        public Country Country
        {
            get { return _country; }
            set { _country = value; }
        }
        public string Name { get; set; }
        public List<City> Cities { get; set; }

    }
    public class Country
    {
        public int CountryId { get; set; }
        public string CountryCode { get; set; }
        public string Name { get; set; }
        public List<State> States { get; set; }
    }
}
