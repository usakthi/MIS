using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Daria.MIS.UI.Web
{
    public class RoleViewModel
    {
        public Role Role { get; set; }
        public string label { get; set; }
        public string value { get; set; }
        public short depth { get; set; }
        public string levelName { get; set; }
        public bool selected { get; set; }
        public List<RoleViewModel> children { get; set; }

        public RoleViewModel TreeData { get; set; }

        public RoleViewModel()
        {

        }


        public RoleViewModel(Role role)
        {
            Role = role;
            TreeData = new RoleViewModel();

            if (role != null && !role.Modules.IsNullOrEmpty())
            {
                TreeData.children = new List<RoleViewModel>();

                foreach (Module m in role.Modules)
                {
                    TreeData.children.Add(new RoleViewModel(m));
                }
            }

        }

        public RoleViewModel(Module module)
        {
            this.label = module.Name;
            this.value = module.Id.ToString();
            this.levelName = "module";
            if (module != null && !module.Features.IsNullOrEmpty())
            {

                this.children = new List<RoleViewModel>();

                foreach (Feature f in module.Features)
                {
                    this.children.Add(new RoleViewModel(f));
                }
                if (module.Features.Any(f => f.IsSelected == true))
                {
                    this.selected = module.IsSelected = true;
                }
            }
        }

        public RoleViewModel(Feature feature)
        {
            this.label = feature.Name;
            this.value = feature.Id.ToString();
            this.levelName = "feature";
            this.selected = feature.IsSelected;
        }

        public Role FormatRole(RoleViewModel viewModel)
        {
            var selectedModules = viewModel.TreeData.children.FindAll(m => (m.levelName == "module"));

            var role = viewModel.Role;

            if (selectedModules != null && selectedModules.Count > 0)
            {
                role.Modules = new List<Module>();

                foreach (RoleViewModel moduleInfo in selectedModules)
                {
                    var selectedFeatures = moduleInfo.children.FindAll(m => (m.levelName == "feature" && m.selected == true));

                    if (selectedFeatures != null && selectedFeatures.Count > 0)
                    {
                        role.Modules.Add(
                        new Module
                        {
                            Features = selectedFeatures.Select(f => new Feature { Id = Convert.ToInt32(f.value) }).ToList()
                        });
                    }
                }

            }

            return role;
        }
    }
}
