locals {
  # --- input context (strings) ---
  id_context = {
    name        = tostring(var.name)
    environment = tostring(var.environment)
    repository  = tostring(var.repository)
    managedby   = tostring(var.managedby)
  }

  # --- label order (use provided or default) ---
  label_order = length(var.label_order) > 0 ? var.label_order : ["name", "environment"]

  # --- collect label values according to order, skipping empty ---
  id_labels = [
    for l in local.label_order :
    lookup(local.id_context, l, "") if length(lookup(local.id_context, l, "")) > 0
  ]

  # --- compact attributes and build id parts (labels + attributes) ---
  attributes_compact = compact(var.attributes)
  id_parts           = compact(concat(local.id_labels, local.attributes_compact))

  # --- final id (joined with delimiter, lowercased) ---
  id = length(local.id_parts) > 0 ? lower(join(var.delimiter, local.id_parts)) : ""

  # --- normalized single fields (only present if enabled) ---
  name        = var.enabled ? lower(tostring(var.name)) : ""
  environment = var.enabled ? lower(tostring(var.environment)) : ""
  managedby   = var.enabled ? lower(tostring(var.managedby)) : ""
  repository  = var.enabled ? lower(tostring(var.repository)) : ""
  attributes  = var.enabled && length(local.attributes_compact) > 0 ? lower(join(var.delimiter, local.attributes_compact)) : ""

  # --- base tag context (provider-neutral values) ---
  tags_context = {
    name        = local.id
    environment = local.environment
    managedby   = local.managedby
    repository  = local.repository
  }

  # --- sanitize helper (chained replace): lowercase then replace common unsafe chars ---
  # note: replace() is literal, so we chain a few common replacements
  # we apply same chain in both normalizations below
  # pattern replaced: space, ".", "/", ":", "@", ","
  # result: only a-z, 0-9, _, - remain from typical inputs (uppercase will be lowercased)
  normalized_base_tags = {
    for k, v in local.tags_context :
    replace(
      replace(
        replace(
          replace(
            replace(
              replace(
                lower(tostring(k)),
                " ", "_"
              ),
              ".", "_"
            ),
            "/", "_"
          ),
          ":", "_"
        ),
        "@", "_"
      ),
      ",", "_"
    ) => tostring(v)
    if length(tostring(v)) > 0
  }

  normalized_extra_tags = {
    for k, v in var.extra_tags :
    replace(
      replace(
        replace(
          replace(
            replace(
              replace(
                lower(tostring(k)),
                " ", "_"
              ),
              ".", "_"
            ),
            "/", "_"
          ),
          ":", "_"
        ),
        "@", "_"
      ),
      ",", "_"
    ) => tostring(v)
    if length(tostring(v)) > 0
  }

  # --- merged lowercase-safe map (base + extra; extra overrides base) ---
  all_tags = merge(local.normalized_base_tags, local.normalized_extra_tags)

  # --- tags for AWS/Azure: TitleCase keys with special Name key ---
  tags = {
    for k, v in local.all_tags :
    (k == "name" ? "Name" : title(replace(k, "_", ""))) => v
  }

  # --- labels for GCP/DO/Hetzner: keep lowercase sanitized keys ---
  labels = local.all_tags
}
